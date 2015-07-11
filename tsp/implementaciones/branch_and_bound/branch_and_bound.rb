require_relative '../aux'
require_relative 'restricciones_tsp'
require 'awesome_print'

class BranchAndBoundTSP

  def initialize(cantidad_de_ciudades, distancias)
    @cantidad_de_ciudades = cantidad_de_ciudades
    @ciudades = 0..@cantidad_de_ciudades-1
    @distancias = distancias
    @total_nodos = 0
    @mejor_cota_inferior = 0
    @mejor_cota_superior = Float::INFINITY
  end

  ### COTA INFERIOR

  def cota_inferior(restricciones)
    total = 0
    @ciudades.each do |i|
      primer_eje_elegido = Float::INFINITY
      primer_eje_elegido_por_ser_minimo = true
      segundo_eje_elegido = Float::INFINITY
      segundo_eje_elegido_por_ser_minimo = true

      @ciudades.each do |j|
        if restricciones.tiene_que_estar?(i, j)
          if primer_eje_elegido_por_ser_minimo
            segundo_eje_elegido = primer_eje_elegido # lo muevo de lugar para que entre el que tiene que estar sí o sí
            primer_eje_elegido = costo_en_llegar_a(i, j, @distancias)
            primer_eje_elegido_por_ser_minimo = false
          elsif segundo_eje_elegido_por_ser_minimo
            segundo_eje_elegido = costo_en_llegar_a(i, j, @distancias)
            segundo_eje_elegido_por_ser_minimo = false
          else
            raise 'error en las definiciones de restricciones del TSP: no puede haber más de 2 ejes incidentes a un mismo vértice'
          end
        elsif i == j
          # nada que hacer
        elsif restricciones.no_tiene_que_estar?(i, j)
          # nada que hacer
        elsif !primer_eje_elegido_por_ser_minimo && !segundo_eje_elegido_por_ser_minimo
          # nada que hacer
        else
          current = costo_en_llegar_a(i, j, @distancias)
          if current < primer_eje_elegido && primer_eje_elegido_por_ser_minimo
            segundo_eje_elegido = primer_eje_elegido
            primer_eje_elegido = current
          elsif current < segundo_eje_elegido && segundo_eje_elegido_por_ser_minimo
            segundo_eje_elegido = current
          end
        end

      end
      total += primer_eje_elegido
      total += segundo_eje_elegido
    end
    total.fdiv(2)
  end

  ### COTA SUPERIOR

  def cota_superior(restricciones)
    copia_de_restricciones = restricciones.clone
    until copia_de_restricciones.hay_tour_completo?
      restriccion_al_azar = copia_de_restricciones.posible_proxima_restriccion
      copia_de_restricciones.incluir restriccion_al_azar[0], restriccion_al_azar[1]
    end

    tour = copia_de_restricciones.tour_completo
    [tour, distancia_para_recorrer(tour)]
  end

  def distancia_para_recorrer(tour)
    distancia = costo_en_llegar_a(0, tour.last, @distancias)
    (1..tour.length-1).each do |i|
      distancia += costo_en_llegar_a(tour[i], tour[i-1], @distancias)
    end
    distancia
  end

  ### BRANCH AND BOUND

  def resolver
    @nodos = []
    @nodos_procesados = 0
    @nodos << nodo_inicial

    @total_nodos = 1

    # puts "RAMIFICACION: #{@total_nodos} nodos activos en total (#{@nodos_procesados} ya procesados): cota inferior #{@mejor_cota_inferior}, cota superior #{@mejor_cota_superior}"

    nodo_actual = proximo_nodo_a_procesar
    calcular_cotas_para(nodo_actual)
    until encontre_solucion_optima?
      if nodo_actual[:restricciones].no_hay_tour_completo?
        @nodos = ramificar(nodo_actual) + @nodos
        # puts "RAMIFICACION: #{@total_nodos} nodos activos en total (#{@nodos_procesados} ya procesados): cota inferior #{@mejor_cota_inferior}, cota superior #{@mejor_cota_superior}"
      else

      end
      @nodos.delete(nodo_actual)
      @nodos_procesados += 1
      nodo_actual = proximo_nodo_a_procesar
      calcular_cotas_para(nodo_actual)
      intentar_podar
      puts "#{@total_nodos} nodos activos en total (#{@nodos_procesados} ya procesados) cota inferior #{@mejor_cota_inferior}, cota superior #{@mejor_cota_superior}"
    end
    @solucion
  end

  def ramificar(nodo)
    nueva_restriccion = nodo[:restricciones].posible_proxima_restriccion
    restricciones_rama_izquierda = nodo[:restricciones].clone
    restricciones_rama_izquierda.incluir nueva_restriccion[0], nueva_restriccion[1]
    rama_izquierda = {
        padre: nodo,
        restricciones: restricciones_rama_izquierda #,
        #paso: "incluir #{nueva_restriccion}"
    }
    @total_nodos += 1
    # puts "BRANCH IZQUIERDO: #{rama_izquierda[:paso]}"
    if nodo[:restricciones].puede_excluir? nueva_restriccion[0], nueva_restriccion[1]
      restricciones_rama_derecha = nodo[:restricciones].clone
      restricciones_rama_derecha.excluir nueva_restriccion[0], nueva_restriccion[1]
      rama_derecha = {
          padre: nodo,
          restricciones: restricciones_rama_derecha #,
          #paso: "excluir #{nueva_restriccion}"
      }
      @total_nodos += 1
      # puts "BRANCH DERECHO: #{rama_derecha[:paso]}"
      [rama_derecha, rama_izquierda]
    else
      [rama_izquierda]
    end
  end

  def proximo_nodo_a_procesar
    @nodos.first
  end

  def encontre_solucion_optima?
    cotas_son_iguales? && !hay_mas_nodos_por_explorar?
  end

  def hay_mas_nodos_por_explorar?
    @nodos.any? { |nodo| !nodo[:cota_superior] || !nodo[:cota_inferior] }
  end

  def cotas_son_iguales?
    @mejor_cota_inferior == @mejor_cota_superior
  end

  def nodo_inicial
    {padre: nil, restricciones: RestriccionesTSP.new(@cantidad_de_ciudades)}
  end

  def calcular_cotas_para(nodo_actual)
    nodo_actual[:cota_inferior] = cota_inferior(nodo_actual[:restricciones])
    nodo_actual[:cota_superior] = cota_superior(nodo_actual[:restricciones])

    propagar_informacion_de_cotas(nodo_actual)
  end

  def propagar_informacion_de_cotas(nodo)
    if nodo[:cota_superior][1] < @mejor_cota_superior
      @mejor_cota_superior = nodo[:cota_superior][1]
      @solucion = nodo[:cota_superior]
    end

    if nodo[:restricciones].hay_tour_completo?
      if @mejor_cota_inferior_es_de_tour_completo
        if nodo[:cota_inferior] < @mejor_cota_inferior
          @mejor_cota_inferior = nodo[:cota_inferior]
          @solucion = [nodo[:restricciones].tour_completo, @mejor_cota_inferior]
        end
      else
        @mejor_cota_inferior_es_de_tour_completo = true
        # sin importar que haya pasado antes, esta es la posta
        @mejor_cota_inferior = nodo[:cota_inferior]
        @solucion = [nodo[:restricciones].tour_completo, @mejor_cota_inferior]
      end
    else
      if !@mejor_cota_inferior_es_de_tour_completo
        if nodo[:cota_inferior] > @mejor_cota_inferior
          @mejor_cota_inferior = nodo[:cota_inferior]
        end
      end
    end

  end

  def intentar_podar
    @nodos.each do |nodo|
      if puede_ser_podado?(nodo)
        @nodos.each do |n|
          if n[:padre] == nodo
            @nodos.delete(n)
            @total_nodos -= 1
          end
        end
        @nodos.delete(nodo)
        @total_nodos -= 1

        # puts "PODA: #{@total_nodos} nodos activos en total (#{@nodos_procesados} ya procesados): cota inferior #{@mejor_cota_inferior}, cota superior #{@mejor_cota_superior}"
      end
    end
  end

  def puede_ser_podado?(nodo)
    return false if nodo[:cota_inferior].nil?
    nodo[:cota_inferior] > @mejor_cota_superior || (@mejor_cota_inferior_es_de_tour_completo && @mejor_cota_inferior < nodo[:cota_inferior])
  end

end

require_relative '../aux'
require_relative 'restricciones_tsp'

class BranchAndBoundTSP

  def initialize(cantidad_de_ciudades, distancias)
    @cantidad_de_ciudades = cantidad_de_ciudades
    @ciudades = 0..@cantidad_de_ciudades-1
    @distancias = distancias
    @nodos = []
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

  def resolver
    @nodos << nodo_inicial
    @total_nodos = 1

    nodo_actual = @nodos.first
    calcular_cotas_para(nodo_actual)
    until encontre_solucion_optima?
      ramificar(nodo_actual) if nodo_actual[:restricciones].no_hay_tour_completo?
      @nodos.delete(nodo_actual)
      nodo_actual = proximo_nodo_a_procesar
      intentar_podar
      puts "#{@total_nodos} nodos en el árbol, cota inferior #{@mejor_cota_inferior}, cota superior #{@mejor_cota_superior}"
    end
    @solucion
  end

  def ramificar(nodo)
    nueva_restriccion = nodo[:restricciones].posible_proxima_restriccion
    restricciones_rama_izquierda = nodo[:restricciones].clone
    restricciones_rama_izquierda.incluir nueva_restriccion[0], nueva_restriccion[1]
    rama_izquierda = { padre: nodo, restricciones: restricciones_rama_izquierda }
    @total_nodos += 1
    calcular_cotas_para(rama_izquierda)
    if nodo[:restricciones].puede_excluir? nueva_restriccion[0], nueva_restriccion[1]
      restricciones_rama_derecha = nodo[:restricciones].clone
      restricciones_rama_derecha.excluir nueva_restriccion[0], nueva_restriccion[1]
      rama_derecha = { padre: nodo, restricciones: restricciones_rama_derecha }
      @total_nodos += 1
      calcular_cotas_para(rama_derecha)
      @nodos.unshift rama_izquierda
      @nodos.unshift rama_derecha
    else
      @nodos.unshift rama_izquierda
    end
  end

  def proximo_nodo_a_procesar
    @nodos.first
  end

  def encontre_solucion_optima?
    cotas_son_iguales? && !hay_mas_nodos_por_explorar?
  end

  def hay_mas_nodos_por_explorar?
    @nodos.any? { |nodo| nodo[:restricciones].no_hay_tour_completo? }
  end

  def cotas_son_iguales?
    @mejor_cota_inferior == @mejor_cota_superior
  end

  def nodo_inicial
    {padre: nil, restricciones: RestriccionesTSP.new(@cantidad_de_ciudades)}
  end

  def calcular_cotas_para(nodo)
    nodo[:cota_inferior] = cota_inferior(nodo[:restricciones])
    nodo[:cota_superior] = cota_superior(nodo[:restricciones])

    propagar_informacion_de_cotas(nodo)
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
        @mejor_cota_inferior = nodo[:cota_inferior]
        @solucion = [nodo[:restricciones].tour_completo, @mejor_cota_inferior]
      end
    else
      if !@mejor_cota_inferior_es_de_tour_completo && nodo[:cota_inferior] > @mejor_cota_inferior
        @mejor_cota_inferior = nodo[:cota_inferior]
      end
    end
  end

  def podar(nodo)
    @nodos.delete(nodo)
    @total_nodos -= 1
    @nodos.each do |n|
      podar(n) if n[:padre] == nodo
    end
  end

  def intentar_podar
    @nodos.each do |nodo|
      podar(nodo) if puede_ser_podado?(nodo)
    end
  end

  def puede_ser_podado?(nodo)
    nodo[:cota_inferior] > @mejor_cota_superior || (@mejor_cota_inferior_es_de_tour_completo && @mejor_cota_inferior < nodo[:cota_inferior])
  end

end

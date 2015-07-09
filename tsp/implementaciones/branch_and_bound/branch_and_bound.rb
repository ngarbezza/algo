require_relative '../aux'
require_relative 'restricciones_tsp'

class BranchAndBoundTSP

  def initialize(cantidad_de_ciudades, distancias)
    @cantidad_de_ciudades = cantidad_de_ciudades
    @ciudades = 0..@cantidad_de_ciudades-1
    @distancias = distancias
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
    # TODO: considerar restricciones
    [[], Float::INFINITY]
    # greedy(cantidad_de_ciudades, 0, distancias)[1]
  end

  ### BRANCH AND BOUND

  def resolver
    @nodos = []
    @nodos_procesados = []
    @nodos << nodo_inicial
    nodo_actual = proximo_nodo_a_procesar
    calcular_cotas_para(nodo_actual)
    until encontre_solucion_optima?
      if !nodo_actual[:restricciones].hay_tour_completo?
        @nodos = ramificar(nodo_actual) + @nodos
      end
      @nodos.delete(nodo_actual)
      @nodos_procesados << nodo_actual
      nodo_actual = proximo_nodo_a_procesar
      calcular_cotas_para(nodo_actual)
      intentar_podar
    end
    @solucion
  end

  def ramificar(nodo)
    nueva_restriccion = nodo[:restricciones].posible_proxima_restriccion
    restricciones_rama_izquierda = nodo[:restricciones].clone
    restricciones_rama_izquierda.incluir nueva_restriccion[0], nueva_restriccion[1]
    restricciones_rama_derecha = nodo[:restricciones].clone
    restricciones_rama_derecha.excluir nueva_restriccion[0], nueva_restriccion[1]
    rama_izquierda = {
        padre: nodo,
        restricciones: restricciones_rama_izquierda
    }
    rama_derecha = {
        padre: nodo,
        restricciones: restricciones_rama_derecha
    }
    [rama_izquierda, rama_derecha]
  end

  def proximo_nodo_a_procesar
    @nodos.first
  end

  def encontre_solucion_optima?
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
    if !@mejor_cota_superior || (nodo[:cota_superior][1] < @mejor_cota_superior)
      @mejor_cota_superior = nodo[:cota_superior][1]
      @solucion = nodo[:cota_superior]
    end
    if !@mejor_cota_inferior || (nodo[:cota_inferior] > @mejor_cota_inferior)
      @mejor_cota_inferior = nodo[:cota_inferior]
      if nodo[:restricciones].hay_tour_completo?
        @mejor_cota_inferior_es_de_tour_completo = true
        @solucion = [nodo[:restricciones].tour_completo, @mejor_cota_inferior]

        # TODO: borrar cuando la cota superior se calcule correctamente, esto hace que NO de una solución óptima
        @mejor_cota_superior = @mejor_cota_inferior
      end
    end
  end

  def intentar_podar
    @nodos.each do |nodo|
      if puede_ser_podado?(nodo)
        @nodos.delete_if { |n| n[:padre] == nodo }
        @nodos.delete(nodo)
      end
    end
  end

  def puede_ser_podado?(nodo)
    return false if nodo[:cota_inferior].nil?
    nodo[:cota_inferior] > @mejor_cota_superior || (@mejor_cota_inferior_es_de_tour_completo && @mejor_cota_inferior < nodo[:cota_inferior])
  end

end

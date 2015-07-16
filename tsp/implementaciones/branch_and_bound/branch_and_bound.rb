require_relative '../aux'
require_relative 'restricciones_tsp'
require_relative 'nodo_tsp'

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

  def cota_inferior(nodo)
    total = 0
    restricciones = nodo.restricciones
    for i in @ciudades
      primer_eje_elegido = Float::INFINITY
      primer_eje_elegido_por_ser_minimo = true
      segundo_eje_elegido = Float::INFINITY
      segundo_eje_elegido_por_ser_minimo = true

      for j in @ciudades
        if i == j
          #nada que hacer
        elsif !primer_eje_elegido_por_ser_minimo && !segundo_eje_elegido_por_ser_minimo
          # nada que hacer
        elsif restricciones.no_tiene_que_estar?(i, j)
          # nada que hacer
        elsif restricciones.tiene_que_estar?(i, j)
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
        else
          current = costo_en_llegar_a(i, j, @distancias)
          if primer_eje_elegido_por_ser_minimo && current < primer_eje_elegido
            segundo_eje_elegido = primer_eje_elegido
            primer_eje_elegido = current
          elsif segundo_eje_elegido_por_ser_minimo && current < segundo_eje_elegido
            segundo_eje_elegido = current
          end
        end

      end
      total += primer_eje_elegido
      total += segundo_eje_elegido
    end
    total.fdiv(2)
  end

  def cota_inferior_hungara(nodo)
    matriz = []
    @ciudades.each do |i|
      matriz << []
      @ciudades.each do |j|
        if i == j || nodo.restricciones.no_tiene_que_estar?(i, j)
          matriz[i][j] = Float::INFINITY # así no lo elige nunca
        elsif nodo.restricciones.tiene_que_estar?(i, j)
          matriz[i][j] = -1 # así lo elige siempre
        else
          matriz[i][j] = costo_en_llegar_a(i, j, @distancias)
        end
      end
    end
    p matriz
    m = HungarianAlgorithm.new(matriz.map(&:clone))
    resultado = m.find_pairings
    dist = 0
    resultado.each do |pair|
      dist += costo_en_llegar_a(pair[0], pair[1], @distancias)
    end
    dist
  end

  ### COTA SUPERIOR

  def cota_superior(nodo)
    tour = nodo.tour_actual.clone
    distancia = nodo.distancia_actual
    actual = tour.last
    until tour.length == @cantidad_de_ciudades
      min = Float::INFINITY
      proxima = nil
      for ciudad in @ciudades
        unless tour.include?(ciudad)
          unless nodo.restricciones.no_tiene_que_estar?(actual, ciudad)
            costo_actual = costo_en_llegar_a(ciudad, actual, @distancias)
            if costo_actual < min
              min = costo_actual
              proxima = ciudad
            end
          end
        end
      end
      if proxima.nil?
        return false # no puedo armar un tour a causa de que realicé muchas exclusiones
      end
      distancia += min
      tour << proxima
      actual = proxima
    end
    # incluir la ciudad inicial para terminar el tour
    distancia += costo_en_llegar_a(0, tour.last, @distancias)
    tour << 0

    [tour, distancia]
  end

  def resolver
    @nodos << nodo_inicial
    @total_nodos = 1

    nodo_actual = @nodos.first
    calcular_cotas_para(nodo_actual)
    until encontre_solucion_optima?
      ramificar(nodo_actual) if nodo_actual.no_hay_tour_completo?
      @nodos.delete(nodo_actual)
      nodo_actual = proximo_nodo_a_procesar
      intentar_podar
      puts "#{@total_nodos} nodos en el árbol, cota inferior #{@mejor_cota_inferior}, cota superior #{@mejor_cota_superior}"
    end
    @solucion
  end

  def ramificar(nodo)
    nueva_restriccion = nodo.posible_proxima_restriccion
    return if !nueva_restriccion

    puedo_ir_a_la_izquierda = nodo.puede_incluir_al_tour? nueva_restriccion
    if puedo_ir_a_la_izquierda
      restricciones_rama_izquierda = nodo.restricciones.clone
      restricciones_rama_izquierda.incluir nodo.extremo, nueva_restriccion
      nuevo_tour = nodo.tour_actual + [nueva_restriccion]
      nueva_distancia = nodo.distancia_actual + costo_en_llegar_a(nueva_restriccion, nodo.extremo, @distancias)
      rama_izquierda = NodoTSP.new nodo, restricciones_rama_izquierda, nuevo_tour, nueva_distancia
      resultado_cotas = calcular_cotas_para(rama_izquierda)
      if resultado_cotas
        nodo.hijo_izquierdo = rama_izquierda
        @total_nodos += 1
        @nodos.unshift rama_izquierda
      else
        # no pude calcular la cota, no considero este nodo
      end
    end

    puedo_ir_a_la_derecha = nodo.puede_excluir_del_tour? nueva_restriccion
    if puedo_ir_a_la_derecha
      restricciones_rama_derecha = nodo.restricciones.clone
      restricciones_rama_derecha.excluir nodo.extremo, nueva_restriccion
      rama_derecha = NodoTSP.new nodo, restricciones_rama_derecha, nodo.tour_actual, nodo.distancia_actual
      resultado_cotas = calcular_cotas_para(rama_derecha)
      if resultado_cotas
        nodo.hijo_derecho = rama_derecha
        @total_nodos += 1
        @nodos.unshift rama_derecha
      else
        # no pude calcular la cota, no considero este nodo
      end
    end
  end

  def proximo_nodo_a_procesar
    @nodos.first
  end

  def encontre_solucion_optima?
    # cotas_son_iguales? && !hay_mas_nodos_por_explorar?
    !hay_mas_nodos_por_explorar?
  end

  def hay_mas_nodos_por_explorar?
    @nodos.any? { |nodo| nodo.no_hay_tour_completo? }
  end

  def cotas_son_iguales?
    @mejor_cota_inferior == @mejor_cota_superior
  end

  def nodo_inicial
    sin_padre = nil
    restricciones = RestriccionesTSP.new(@cantidad_de_ciudades)
    ciudad_inicial = 0
    tour_inicial = [ciudad_inicial]
    distancia_inicial = 0
    NodoTSP.new sin_padre, restricciones, tour_inicial, distancia_inicial
  end

  def calcular_cotas_para(nodo)
    cota_superior_resultado = cota_superior(nodo)
    return false unless cota_superior_resultado
    nodo.cota_superior = cota_superior_resultado
    # nodo.cota_inferior = cota_inferior(nodo) # 55608, 18s
    nodo.cota_inferior = cota_inferior_hungara(nodo) # 15102, 20s

    propagar_informacion_de_cotas(nodo)
    true
  end

  def propagar_informacion_de_cotas(nodo)
    # TODO: testear, hay varios casos

    if nodo.cota_superior[1] < @mejor_cota_superior
      @mejor_cota_superior = nodo.cota_superior[1]
      @solucion = nodo.cota_superior
    end

    if nodo.hay_tour_completo? #cota superior e inferior deberían coincidir

      if @mejor_cota_inferior_es_de_tour_completo
        if nodo.cota_inferior < @mejor_cota_inferior
          @mejor_cota_inferior = nodo.cota_inferior
          @solucion = nodo.cota_superior
        end
      else
        @mejor_cota_inferior_es_de_tour_completo = true
        @mejor_cota_inferior = nodo.cota_inferior
        @solucion = nodo.cota_superior
      end
    else
      if !@mejor_cota_inferior_es_de_tour_completo && nodo.cota_inferior > @mejor_cota_inferior
        @mejor_cota_inferior = nodo.cota_inferior
      end
    end

    if @mejor_cota_superior < @mejor_cota_inferior
      @mejor_cota_inferior = @mejor_cota_superior
    end

  end

  def podar(nodo)
    @nodos.delete(nodo)
    @total_nodos -= 1
    podar(nodo.hijo_izquierdo) if nodo.hijo_izquierdo
    podar(nodo.hijo_derecho) if nodo.hijo_derecho
  end

  def intentar_podar
    @nodos.each do |nodo|
      podar(nodo) if puede_ser_podado?(nodo)
    end
  end

  def puede_ser_podado?(nodo)
    cota_solucion = @mejor_cota_inferior_es_de_tour_completo ? @mejor_cota_inferior : @mejor_cota_superior
    nodo_no_puede_alcanzar_una_mejor_cota = nodo.cota_inferior > cota_solucion
    cotas_son_iguales = nodo.cota_inferior == nodo.cota_superior
    nodo_no_puede_alcanzar_una_mejor_cota || cotas_son_iguales
  end

end

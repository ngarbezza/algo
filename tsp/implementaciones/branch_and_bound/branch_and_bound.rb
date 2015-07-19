require_relative 'restricciones_tsp'
require_relative 'nodo_tsp'
require_relative 'calculador_de_cota_inferior'
require_relative 'calculador_de_cota_superior'

class BranchAndBoundTSP

  def initialize(distancias, configuracion)
    @cantidad_de_ciudades = distancias.length
    @ciudades = 0..@cantidad_de_ciudades-1
    @distancias = distancias
    @nodos = []
    @total_nodos = 0
    @mejor_cota_inferior = 0
    @mejor_cota_superior = Float::INFINITY
    @calculador_de_cota_inferior = configuracion[:calculador_de_cota_inferior].new(@cantidad_de_ciudades, distancias)
    @calculador_de_cota_superior = configuracion[:calculador_de_cota_superior].new(@cantidad_de_ciudades, distancias)
    @log = configuracion[:log_salida]
    @procesar_ultimos_nodos_primero = configuracion[:procesar_ultimos_nodos_primero]
    @procesar_rama_izquierda_primero = configuracion[:procesar_rama_izquierda_primero]
    @procesar_nodos_al_azar = configuracion[:procesar_nodos_al_azar]
  end

  def resolver
    nodo_actual = inicializar_resolucion
    while hay_mas_nodos_por_explorar?
      ramificar(nodo_actual) if nodo_actual.no_hay_tour_completo?
      nodo_actual = procesar(nodo_actual)
      intentar_podar
      log_paso
    end
    @solucion + [@total_nodos]
  end

  def log_paso
    if @log
      puts "#{@total_nodos} nodos en el árbol, cota inferior #{@mejor_cota_inferior}, cota superior #{@mejor_cota_superior}"
    end
  end

  def inicializar_resolucion
    nodo = nodo_inicial
    @nodos << nodo
    @total_nodos = 1
    calcular_cotas_para(nodo)
    nodo
  end

  def procesar(nodo_actual)
    @nodos.delete(nodo_actual)
    proximo_nodo_a_procesar
  end

  def ramificar(nodo)
    nueva_restriccion = nodo.posible_proxima_restriccion
    return unless nueva_restriccion

    if @procesar_rama_izquierda_primero
      agregar_rama_derecha(nodo, nueva_restriccion)
      agregar_rama_izquierda(nodo, nueva_restriccion)
    else
      agregar_rama_izquierda(nodo, nueva_restriccion)
      agregar_rama_derecha(nodo, nueva_restriccion)
    end
  end

  def agregar_rama_izquierda(nodo, nueva_restriccion)
    if nodo.puede_incluir_al_tour? nueva_restriccion
      restricciones_rama_izquierda = nodo.restricciones.clone
      restricciones_rama_izquierda.incluir nodo.extremo, nueva_restriccion
      nuevo_tour = nodo.tour_actual + [nueva_restriccion]
      nueva_distancia = nodo.distancia_actual + @distancias[nueva_restriccion][nodo.extremo]
      rama_izquierda = NodoTSP.new restricciones_rama_izquierda, nuevo_tour, nueva_distancia
      resultado_cotas = calcular_cotas_para(rama_izquierda)
      if resultado_cotas
        nodo.hijo_izquierdo = rama_izquierda
        @total_nodos += 1
        @nodos.unshift rama_izquierda
      end
    end
  end

  def agregar_rama_derecha(nodo, nueva_restriccion)
    if nodo.puede_excluir_del_tour? nueva_restriccion
      restricciones_rama_derecha = nodo.restricciones.clone
      restricciones_rama_derecha.excluir nodo.extremo, nueva_restriccion
      rama_derecha = NodoTSP.new restricciones_rama_derecha, nodo.tour_actual, nodo.distancia_actual
      resultado_cotas = calcular_cotas_para(rama_derecha)
      if resultado_cotas
        nodo.hijo_derecho = rama_derecha
        @total_nodos += 1
        @nodos.unshift rama_derecha
      end
    end
  end

  def proximo_nodo_a_procesar
    if @procesar_nodos_al_azar
      @nodos.sample
    elsif @procesar_ultimos_nodos_primero
      @nodos.first
    else
      @nodos.last
    end
  end

  def hay_mas_nodos_por_explorar?
    @nodos.any? { |nodo| nodo.no_hay_tour_completo? }
  end

  def nodo_inicial
    restricciones = RestriccionesTSP.new(@cantidad_de_ciudades)
    ciudad_inicial = 0
    tour_inicial = [ciudad_inicial]
    distancia_inicial = 0
    NodoTSP.new restricciones, tour_inicial, distancia_inicial
  end

  def calcular_cotas_para(nodo)
    cota_superior_resultado = @calculador_de_cota_superior.calcular(nodo)
    return false unless cota_superior_resultado
    nodo.cota_superior = cota_superior_resultado
    nodo.cota_inferior = @calculador_de_cota_inferior.calcular(nodo)

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
    nodo_no_puede_alcanzar_una_mejor_cota = nodo.cota_inferior >= cota_solucion
    cotas_son_iguales = nodo.cota_inferior == nodo.cota_superior[1]
    nodo_no_puede_alcanzar_una_mejor_cota || cotas_son_iguales
  end

end

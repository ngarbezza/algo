class NodoTSP

  attr_reader :restricciones
  attr_accessor :hijo_izquierdo, :hijo_derecho, :cota_inferior, :cota_superior, :tour_actual, :distancia_actual

  def initialize(padre, restricciones, tour_actual, distancia_actual)
    @padre = padre
    @restricciones = restricciones
    @tour_actual = tour_actual
    @distancia_actual = distancia_actual
  end

  def hay_tour_completo?
    @tour_actual.length == restricciones.cantidad_de_ciudades + 1
  end

  def no_hay_tour_completo?
    !hay_tour_completo?
  end

  def en_el_ultimo_paso_del_tour?
    @tour_actual.length == @restricciones.cantidad_de_ciudades
  end

  def extremo
    @tour_actual.last
  end

  def posible_proxima_restriccion
    @restricciones.posible_proxima_restriccion(@tour_actual, en_el_ultimo_paso_del_tour?)
  end

  def puede_incluir_al_tour?(hasta)
    @restricciones.puede_incluir?(extremo, hasta)
  end

  def puede_excluir_del_tour?(hasta)
    @restricciones.puede_excluir?(extremo, hasta) && hay_mas_de_una_forma_de_volver?
  end

  def hay_mas_de_una_forma_de_volver?
    # cuando estoy en el anteúltimo lugar del tour, sólo hay una forma de volver, que es
    # visitando la ciudad que me queda y volver al inicio.
    @tour_actual.length < (@restricciones.cantidad_de_ciudades - 1)
  end

end

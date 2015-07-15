class NodoTSP

  attr_reader :restricciones, :cadena
  attr_accessor :hijo_izquierdo, :hijo_derecho, :cota_inferior, :cota_superior

  def initialize(padre, restricciones, cadena)
    @padre = padre
    @restricciones = restricciones
    @cadena = cadena
  end

  def hay_tour_completo?
    @cadena[:visitados].length == restricciones.cantidad_de_ciudades
  end

  def no_hay_tour_completo?
    @cadena[:visitados].length < restricciones.cantidad_de_ciudades
  end

  def tour_completo
    @cadena[:visitados] + [@cadena[:extremo]]
  end

  def posible_proxima_restriccion
    @restricciones.posible_proxima_restriccion(@cadena[:extremo],
                                               @cadena[:visitados],
                                               @cadena[:visitados].length + 1 == @restricciones.cantidad_de_ciudades)
  end

  def puede_excluir?(desde, hasta)
    @restricciones.puede_excluir?(desde, hasta) && (@cadena[:visitados].length < (@restricciones.cantidad_de_ciudades - 2))
  end

  def puede_incluir?(desde, hasta)
    @restricciones.puede_incluir?(desde, hasta)
  end

end

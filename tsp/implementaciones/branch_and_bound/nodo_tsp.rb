class NodoTSP

  attr_reader :restricciones
  attr_accessor :hijo_izquierdo, :hijo_derecho, :cota_inferior, :cota_superior

  def initialize(padre, restricciones)
    @padre = padre
    @restricciones = restricciones
  end

end

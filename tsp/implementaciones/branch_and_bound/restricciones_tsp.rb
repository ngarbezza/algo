class RestriccionesTSP

  attr_reader :restricciones, :cantidad_de_ciudades

  def initialize(ciudades, inclusiones=nil, restricciones=nil, cantidad_de_inclusiones=0)
    @cantidad_de_ciudades = ciudades
    @ciudades = 0..@cantidad_de_ciudades-1
    @inclusiones = inclusiones || [0] * @cantidad_de_ciudades
    @cantidad_de_inclusiones = cantidad_de_inclusiones
    @restricciones = restricciones || inicializar_matriz_de_restricciones
  end

  def tiene_que_estar?(desde, hasta)
    @restricciones[desde][hasta] == 1 || @restricciones[hasta][desde] == 1
  end

  def no_tiene_que_estar?(desde, hasta)
    @restricciones[desde][hasta] == -1 || @restricciones[hasta][desde] == -1
  end

  def incluir(desde, hasta)
    @restricciones[desde][hasta] = 1
    @restricciones[hasta][desde] = 1
    @inclusiones[desde] = @inclusiones[desde] + 1
    @inclusiones[hasta] = @inclusiones[hasta] + 1
    @cantidad_de_inclusiones += 1
  end

  def desincluir(desde, hasta)
    @restricciones[desde][hasta] = 0
    @restricciones[hasta][desde] = 0
    @inclusiones[desde] = @inclusiones[desde] - 1
    @inclusiones[hasta] = @inclusiones[hasta] - 1
    @cantidad_de_inclusiones -= 1
  end

  def excluir(desde, hasta)
    @restricciones[desde][hasta] = -1
    @restricciones[hasta][desde] = -1
  end

  def desexcluir(desde, hasta)
    @restricciones[desde][hasta] = 0
    @restricciones[hasta][desde] = 0
  end

  def posible_proxima_restriccion(visitados, ultimo_paso)
    extremo = visitados.last
    for ciudad in @ciudades
      ya_visitado = visitados.include?(ciudad)
      termina_el_ciclo = ultimo_paso && visitados.include?(0)
      if @restricciones[extremo][ciudad] == 0 && (!ya_visitado || termina_el_ciclo)
        return ciudad
      end
    end

    false
  end

  def clone
    self.class.new @cantidad_de_ciudades, @inclusiones.clone, @restricciones.map(&:clone), @cantidad_de_inclusiones
  end

  def puede_excluir?(desde, hasta)
    excluir(desde, hasta)
    valido = es_valido?
    desexcluir(desde, hasta)
    valido
  end

  def puede_incluir?(desde, hasta)
    incluir(desde, hasta)
    valido = es_valido?
    desincluir(desde, hasta)
    valido
  end

  def es_valido?
    !@ciudades.any? do |ciudad|
      (@inclusiones[ciudad] > 2) || (@restricciones[ciudad].count(-1) > (@cantidad_de_ciudades-2))
    end
  end

  private

  def inicializar_matriz_de_restricciones
    @ciudades.map { |i| @ciudades.map { |j| i != j ? 0 : -1 } }
  end

end

class RestriccionesTSP

  attr_reader :cantidad_de_inclusiones, :cantidad_de_exclusiones

  def initialize(ciudades, inclusiones=0, exclusiones=0, restricciones=nil)
    @cantidad_de_ciudades = ciudades
    @ciudades = 0..@cantidad_de_ciudades-1
    @cantidad_de_inclusiones = inclusiones
    @cantidad_de_exclusiones = exclusiones
    @restricciones = restricciones || inicializar_matriz_de_restricciones
  end

  def tiene_que_estar?(desde, hasta)
    @restricciones[desde][hasta] == 1 || @restricciones[hasta][desde] == 1
  end

  def no_tiene_que_estar?(desde, hasta)
    @restricciones[desde][hasta] == -1 || @restricciones[hasta][desde] == -1
  end

  def da_lo_mismo_que_este?(desde, hasta)
    @restricciones[desde][hasta] == 0 || @restricciones[hasta][desde] == 0
  end

  def incluir(desde, hasta)
    @restricciones[desde][hasta] = 1
    @restricciones[hasta][desde] = 1
    realizar_inferencias_de_inclusion
    @cantidad_de_inclusiones += 1
  end

  def excluir(desde, hasta)
    @restricciones[desde][hasta] = -1
    @restricciones[hasta][desde] = -1
    realizar_inferencias_de_exclusion
    @cantidad_de_exclusiones += 1
  end

  def posible_proxima_restriccion
    # TODO chequear si funciona en todos los casos
    @ciudades.each do |i|
      @ciudades.each do |j|
        return [i, j] if @restricciones[i][j] == 0
      end
    end

    raise 'ya existen todas las restricciones posibles'
  end

  def clone
    self.class.new @cantidad_de_ciudades,
                   @cantidad_de_inclusiones,
                   @cantidad_de_exclusiones,
                   @restricciones.map(&:clone)
  end

  private

  def inicializar_matriz_de_restricciones
    @ciudades.map { |i| @ciudades.map { |j| i != j ? 0 : -1 } }
  end

  def realizar_inferencias_de_inclusion
    mantener_siempre_2_ejes_incidentes_por_cada_vertice
    evitar_ciclos_prematuros
    incluir_ejes_que_deben_estar_si_o_si_en_el_tour
  end

  def realizar_inferencias_de_exclusion
    incluir_ejes_que_deben_estar_si_o_si_en_el_tour
  end

  def incluir_ejes_que_deben_estar_si_o_si_en_el_tour
    @ciudades.each do |i|
      ceros = @restricciones[i].count(0)
      unos = @restricciones[i].count(1)
      if (ceros == 2 && unos == 0) || (ceros == 1 && unos == 1)
        @ciudades.each do |j|
          if @restricciones[i][j] == 0
            @restricciones[i][j] = 1
            @restricciones[j][i] = 1
            @cantidad_de_inclusiones += 1
          end
        end
      end
    end
  end

  def evitar_ciclos_prematuros
    @ciudades.each do |i|
      @ciudades.each do |j|
        if @restricciones[i][j] == 0
          @restricciones[i][j] = 1
          @restricciones[j][i] = 1
          if hay_ciclo_que_no_forma_tour?
            @restricciones[i][j] = -1
            @restricciones[j][i] = -1
            @cantidad_de_exclusiones += 1
          else
            @restricciones[i][j] = 0
            @restricciones[j][i] = 0
          end
        end
      end
    end
  end

  def mantener_siempre_2_ejes_incidentes_por_cada_vertice
    @ciudades.each do |i|
      if @restricciones[i].count(1) == 2 # dos adyacentes
        @ciudades.each do |j|
          if @restricciones[i][j] == 0
            @restricciones[i][j] = -1
            @restricciones[j][i] = -1
            @cantidad_de_exclusiones += 1
          end
        end
      end
    end
  end

  def hay_ciclo_que_no_forma_tour?
    hay_ciclo?(@restricciones) && @ciudades.any? { |c| @restricciones[c].count(1) != 2 }
  end

end

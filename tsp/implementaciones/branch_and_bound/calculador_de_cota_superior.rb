class CalculadorDeCotaSuperior

  def initialize(cantidad_de_ciudades, distancias)
    @cantidad_de_ciudades = cantidad_de_ciudades
    @distancias = distancias
    @ciudades = 0..cantidad_de_ciudades-1
  end

  def calcular(nodo)
    raise 'subclass responsibility'
  end

end

class VecinoMasCercano < CalculadorDeCotaSuperior

  def calcular(nodo)
    tour = nodo.tour_actual.clone
    distancia = nodo.distancia_actual
    actual = tour.last
    posibles_lugares_donde_ir = {}
    tour_finalizado = false
    until tour_finalizado
      until tour.length == @cantidad_de_ciudades
        min = Float::INFINITY
        proxima = nil
        if posibles_lugares_donde_ir[actual].nil? || posibles_lugares_donde_ir[actual].empty?
          posibles_lugares_donde_ir[actual] ||= []
          for ciudad in @ciudades
            unless nodo.restricciones.no_tiene_que_estar?(actual, ciudad) || tour.include?(ciudad)
              posibles_lugares_donde_ir[actual] << ciudad
              costo_actual = @distancias[ciudad][actual]
              if costo_actual < min
                min = costo_actual
                proxima = ciudad
              end
            end
          end
        else
          # caso en el que retrocedí y tengo que buscar un nuevo camino, por ende, ya sé a qué lugares puedo ir
          for ciudad in posibles_lugares_donde_ir[actual]
            unless tour.include?(ciudad)
              costo_actual = @distancias[ciudad][actual]
              if costo_actual < min
                min = costo_actual
                proxima = ciudad
              end
            end
          end
        end
        return false if posibles_lugares_donde_ir[actual].empty? || proxima.nil? # acá sí me puedo ir
        distancia += min
        tour << proxima
        actual = proxima
      end

      if nodo.restricciones.no_tiene_que_estar?(tour.last, 0)
        # o no, porque tengo restricción en ese eje
        posibles_lugares_donde_ir[actual] ||= []
        while posibles_lugares_donde_ir[actual].length <= 1
          anterior = tour.last
          tour.delete anterior
          distancia -= @distancias[actual][tour.last]
          actual = tour.last
          return false if posibles_lugares_donde_ir[actual].nil? || posibles_lugares_donde_ir[actual].empty? # retrocedí demasiado, ya no hay chance de componer el tour
        end
        posibles_lugares_donde_ir[actual].delete anterior
      else
        # incluir la ciudad inicial para terminar el tour
        distancia += @distancias[0][tour.last]
        tour << 0
        tour_finalizado = true
      end
    end

    [tour, distancia]
  end

end

require_relative '../hungarian'

class CalculadorDeCotaInferior

  def initialize(cantidad_de_ciudades, distancias)
    @ciudades = 0..cantidad_de_ciudades-1
    @distancias = distancias
  end

  def calcular(nodo)
    raise 'subclass responsibility'
  end

end

class SumaDeDosEjesConMenorPesoPorCadaVertice < CalculadorDeCotaInferior

  def calcular(nodo)
    total = 0
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
        elsif nodo.restricciones.no_tiene_que_estar?(i, j)
          # nada que hacer
        elsif nodo.restricciones.tiene_que_estar?(i, j)
          if primer_eje_elegido_por_ser_minimo
            segundo_eje_elegido = primer_eje_elegido # lo muevo de lugar para que entre el que tiene que estar sí o sí
            primer_eje_elegido = @distancias[i][j]
            primer_eje_elegido_por_ser_minimo = false
          elsif segundo_eje_elegido_por_ser_minimo
            segundo_eje_elegido = @distancias[i][j]
            segundo_eje_elegido_por_ser_minimo = false
          else
            raise 'error en las definiciones de restricciones del TSP: no puede haber más de 2 ejes incidentes a un mismo vértice'
          end
        else
          current = @distancias[i][j]
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

end

class AlgoritmoHungaro < CalculadorDeCotaInferior

  def calcular(nodo)
    alg = HungarianAlgorithm.new(matriz_de_entrada(nodo.restricciones))
    resultado = alg.find_pairings
    dist = 0
    resultado.each do |pair|
      dist += @distancias[pair[0]][pair[1]]
    end
    dist
  end


  def matriz_de_entrada(restricciones)
    matriz = []
    @ciudades.each do |i|
      matriz[i] = []
      @ciudades.each do |j|
        if i == j || restricciones.no_tiene_que_estar?(i, j)
          matriz[i][j] = Float::INFINITY           # así no lo elige nunca
        elsif restricciones.tiene_que_estar?(i, j)
          matriz[i][j] = -1                        # así lo elige siempre
        else
          matriz[i][j] = @distancias[i][j]
        end
      end
    end
    matriz
  end

end

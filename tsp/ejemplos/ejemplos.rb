require_relative '../tsp'

def ejemplo_4(algoritmo)
  # resultado óptimo esperado:
  #
  #  recorrido: 0 -> 1 -> 2 -> 3 -> 0
  #  distancia: 6
  #
  tsp algoritmo, 4, 0, matriz_de_distancias(4)
end

def ejemplo_5(algoritmo)
  # resultado óptimo esperado:
  #
  #  recorrido: 0 -> 2 -> 1 -> 4 -> 3 -> 0
  #  distancia: 19
  #
  tsp algoritmo, 5, 0, matriz_de_distancias(5)
end

def ejemplo_6(algoritmo)
  # resultado óptimo esperado:
  #
  #  recorrido: 0 -> 2 -> 1 -> 4 -> 3 -> -> 5 -> 0
  #  distancia: 15
  #
  tsp algoritmo, 6, 0, matriz_de_distancias(6)
end

def ejemplo_11(algoritmo)
  # resultado óptimo esperado:
  #
  #  recorrido: 0 -> 7 -> 4 -> 3 -> 9 -> 5 -> 2 -> 6 -> 1 -> 10 -> 8 -> 0
  #  distancia: 253
  #
  tsp algoritmo, 11, 0, matriz_de_distancias(11)
end

CARPETA_EJEMPLOS = 'ejemplos'

def matriz_de_distancias(numero_de_ejemplo)
  leer_instancia "#{CARPETA_EJEMPLOS}/#{numero_de_ejemplo}"
end

def leer_instancia(ejemplo)
  File.readlines(ejemplo).map { |line| line.split(/\W+/).map(&:to_i) }
end

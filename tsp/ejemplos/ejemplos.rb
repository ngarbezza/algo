require_relative '../tsp'

def leer_ejemplo(ejemplo)
  File.readlines(ejemplo).map { |line| line.split(/\W+/).map(&:to_i) }
end

def ejemplo_4(algoritmo)
  # resultado esperado:
  #  recorrido: 0 -> 1 -> 2 -> 3 -> 0
  #  distancia: 6
  tsp algoritmo, 4, 0, leer_ejemplo('ejemplos/4')
end

def ejemplo_11(algoritmo)
  # resultado esperado:
  #  recorrido: 0 -> 7 -> 4 -> 3 -> 9 -> 5 -> 2 -> 6 -> 1 -> 10 -> 8 -> 0
  #  distancia: 253
  tsp algoritmo, 11, 0, leer_ejemplo('ejemplos/11')
end

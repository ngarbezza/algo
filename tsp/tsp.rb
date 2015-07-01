require_relative 'implementaciones/backtracking'
require_relative 'implementaciones/greedy'

def tsp(algoritmo, cantidad_de_ciudades, ciudad_inicial, distancias)
  send algoritmo, cantidad_de_ciudades, ciudad_inicial, distancias
end

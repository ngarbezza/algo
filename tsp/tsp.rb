require_relative 'implementaciones/backtracking'
require_relative 'implementaciones/greedy'
require_relative 'implementaciones/branch_and_bound'

def tsp(algoritmo, cantidad_de_ciudades, ciudad_inicial, distancias)
  send algoritmo, cantidad_de_ciudades, ciudad_inicial, distancias
end

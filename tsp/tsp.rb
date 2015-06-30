require_relative 'backtracking'

def tsp(algoritmo, cantidad_de_ciudades, ciudad_inicial, distancias)
  send algoritmo, cantidad_de_ciudades, ciudad_inicial, distancias
end

def backtracking(cantidad_de_ciudades, ciudad_inicial, distancias)
  ciudades_por_visitar = (0..cantidad_de_ciudades-1).to_a - [ciudad_inicial]
  tsp_backtracking ciudades_por_visitar, [ciudad_inicial], 0, distancias
end

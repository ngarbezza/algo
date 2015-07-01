require_relative 'aux'

# Interfaz pública

def backtracking(cantidad_de_ciudades, ciudad_inicial, distancias)
  ciudades_por_visitar = (0..cantidad_de_ciudades-1).to_a - [ciudad_inicial]
  tsp_backtracking ciudades_por_visitar, [ciudad_inicial], 0, distancias
end

# Algoritmo principal

def tsp_backtracking(ciudades_por_visitar, ciudades_visitadas, distancia_recorrida, distancias)
  if ciudades_por_visitar.empty?
    mejor_recorrido = ciudades_visitadas
    mejor_distancia = distancia_recorrida
  else
    mejor_recorrido = ciudades_visitadas
    mejor_distancia = Float::INFINITY

    ciudades_por_visitar.each do |ciudad|
      tsp_para_ciudad_actual = tsp_backtracking(
          ciudades_por_visitar - [ciudad],
          ciudades_visitadas + [ciudad],
          distancia_recorrida + costo_en_llegar_a(ciudad, ciudades_visitadas.last, distancias),
          distancias)

      if tsp_para_ciudad_actual[1] < mejor_distancia
        mejor_recorrido = tsp_para_ciudad_actual[0]
        mejor_distancia = tsp_para_ciudad_actual[1]
      end
    end

    if debe_terminar_recorrido?(mejor_recorrido)
      mejor_distancia += costo_en_llegar_a(mejor_recorrido.first, mejor_recorrido.last, distancias)
      mejor_recorrido << mejor_recorrido.first
    end
  end
  [mejor_recorrido, mejor_distancia]
end

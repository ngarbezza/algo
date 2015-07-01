require_relative 'aux'

# Interfaz pública

def greedy(cantidad_de_ciudades, ciudad_inicial, distancias)
  recorrido = [ciudad_inicial]
  ciudades_por_visitar = (0..cantidad_de_ciudades-1).to_a - recorrido
  distancia_total = 0

  until ciudades_por_visitar.empty?
    distancia_minima = Float::INFINITY
    ciudad_con_distancia_minima = nil
    ciudades_por_visitar.each do |ciudad|
      costo_en_llegar_a_ciudad = costo_en_llegar_a(ciudad, recorrido.last, distancias)
      if costo_en_llegar_a_ciudad < distancia_minima
        distancia_minima = costo_en_llegar_a_ciudad
        ciudad_con_distancia_minima = ciudad
      end
    end[ciudad_inicial]
    recorrido << ciudad_con_distancia_minima
    ciudades_por_visitar.delete ciudad_con_distancia_minima
    distancia_total += distancia_minima
  end

  distancia_total += costo_en_llegar_a(ciudad_inicial, recorrido.last, distancias)
  recorrido << ciudad_inicial

  [recorrido, distancia_total]
end

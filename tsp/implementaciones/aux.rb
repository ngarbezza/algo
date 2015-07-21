# Definiciones auxiliares

def costo_en_llegar_a(una_ciudad, ciudad_anterior, distancias)
  return 0 if ciudad_anterior.nil?
  distancias[una_ciudad][ciudad_anterior]
end

def debe_terminar_recorrido?(un_recorrido)
  un_recorrido.last != un_recorrido.first
end

def calcular_distancia_total(tour, distancias)
  distancia_total = 0
  actual = 0
  tour.each do |ciudad|
    distancia_total += costo_en_llegar_a(ciudad, actual, distancias)
    actual = ciudad
  end
  distancia_total
end

# Detección de ciclos en grafo representado con matriz de adyacencias
# TODO: mejorar!

def hay_ciclo?(gm)
  # gm denota un grafo implementado con una matriz de adyacencias
  vs = [false] * gm.length # inicializar vector de visitados
  for i in 0..gm.length-1
    unless vs[i]         # si no lo visité antes
      vs[i] = true       # visitado
      return true if hay_ciclo_en_contexto(gm, i, i, vs)
    end
  end
  false
end

def hay_ciclo_comenzando_por(gm, i)
  # gm denota un grafo implementado con una matriz de adyacencias
  vs = [false] * gm.length # inicializar vector de visitados
  vs[i] = true       # visitado
  hay_ciclo_en_contexto(gm, i, i, vs)
end

def hay_ciclo_en_contexto(gm, s, p, vs)
  # detecta un ciclo en un grafo comenzando por un vértice s,
  # viniendo de un vértice p. teniendo en cuenta ciertos nodos
  # visitados denotados por el arreglo vs
  for v in 0..gm[s].length-1
    e = gm[s][v]
    if e == 1
      if p != v                # se excluye el lugar desde donde venimos
        return true if vs[v]   # ciclo detectado
        vs[v] = true
        return true if hay_ciclo_en_contexto(gm, v, s, vs)
      end
    end
  end

  false
end

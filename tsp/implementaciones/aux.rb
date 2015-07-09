# Definiciones auxiliares

def costo_en_llegar_a(una_ciudad, ciudad_anterior, distancias)
  return 0 if ciudad_anterior.nil?
  distancias[una_ciudad][ciudad_anterior]
end

def debe_terminar_recorrido?(un_recorrido)
  un_recorrido.last != un_recorrido.first
end

# Detección de ciclos en grafo representado con matriz de adyacencias
# TODO: mejorar!

def hay_ciclo?(gm)
  # gm denota un grafo implementado con una matriz de adyacencias
  vs = [false] * gm.length # inicializar vector de visitados
  (0..gm.length-1).each do |i|
    unless vs[i]         # si no lo visité antes
      vs[i] = true       # visitado
      return true if hay_ciclo_en_contexto(gm, i, i, vs)
    end
  end
  false
end

def hay_ciclo_en_contexto(gm, s, p, vs)
  # detecta un ciclo en un grafo comenzando por un vértice s,
  # viniendo de un vértice p. teniendo en cuenta ciertos nodos
  # visitados denotados por el arreglo vs
  adyacentes = []
  gm[s].each_with_index do |e, i|
    if e == 1
      adyacentes << i
    end
  end

  adyacentes.each do |v|
    if p != v                # se excluye el lugar desde donde venimos
      return true if vs[v]   # ciclo detectado
      vs[v] = true
      return true if hay_ciclo_en_contexto(gm, v, s, vs)
    end
  end
  false
end

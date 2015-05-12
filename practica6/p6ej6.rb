def hay_ciclo?(gl)
  # gl denota un grafo implementado con una lista de adyacencias
  vs = [false] * gl.length # inicializar vector de visitados
  (0..gl.length-1).each do |i|
    unless vs[i]         # si no lo visité antes
      vs[i] = true       # visitado
      return true if hay_ciclo_en_contexto(gl, i, i, vs)
    end
  end
  false
end

def hay_ciclo_en_contexto(gl, s, p, vs)
  # detecta un ciclo en un grafo comenzando por un vértice s,
  # viniendo de un vértice p. teniendo en cuenta ciertos nodos
  # visitados denotados por el arreglo vs
  gl[s].each do |v|
    if p != v                # se excluye el lugar desde donde venimos
      return true if vs[v]   # ciclo detectado
      vs[v] = true
      return true if hay_ciclo_en_contexto(gl, v, s, vs)
    end
  end
  false
end

puts hay_ciclo?([[1,2], [0,2], [0,1]])
puts !hay_ciclo?([[], [], []])
puts !hay_ciclo?([[1,2,3], [4], [], [], []])
puts !hay_ciclo?([[1], [0,2,3], [1], [1]])

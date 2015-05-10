def hay_ciclo?(gl)
  # gl denota un grafo implementado con una lista de adyacencias
  vs = [false] * gl.length # inicializar vector de visitados
  for i in 0..gl.length-1
    unless vs[i] # si no lo visité antes
      vs[i] = true # visitado
      return true if hay_ciclo_aux(gl, i, vs)
    end
  end
  false
end

def hay_ciclo_aux(gl, s, vs)
  # detecta un ciclo en un grafo comenzando por un vértice s
  gl[s].each do |v|
    return true if vs[v]
    vs[v] = true # visitado
    return true if hay_ciclo_aux(gl, v, vs)
  end
  false
end

puts hay_ciclo?([[1,2], [0,2], [0,1]])
puts hay_ciclo?([[], [], []])
puts hay_ciclo?([[1,2,3], [4], [], [], []])
puts hay_ciclo?([[1], [2,3], [3,4], [2]])

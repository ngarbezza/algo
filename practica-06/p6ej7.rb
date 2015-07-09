def todos_en_circuito_simple?(g)
  # para todo e conectando u,v
  # sea g' = g - e
  # si no hay camino de u a v en g'
  #  return false
  # return true
end

def hay_camino?(gl, d, h)
  hay_camino_aux(gl, d, h, [false] * gl.length)
end

def hay_camino_aux(gl, d, h, vs)
  vs[d] = true
  gl[d].each do |v|
    unless vs[v]
      vs[v] = true
      return true if v == h || hay_camino_aux(gl, v, h, vs)
    end
  end
  false
end

def hay_ciclo?(gl, v)
  hay_camino?(gl, v, v)
end

gm = [[0,1,1],
      [1,0,1],
      [1,1,0]]

gl = [[1,2], [0,2], [0,1]]
# gl = [[1],[0,2],[1]]

puts hay_ciclo?(gl, 0)
puts hay_ciclo?(gl, 1)
puts hay_ciclo?(gl, 2)
puts hay_camino?(gl, 0, 1)
puts hay_camino?(gl, 0, 2)

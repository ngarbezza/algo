def cantidad_de_componentes_conexas(gl)
  vs = [false] * gl.length
  s = 0 # partimos de un vértice arbitrario
  cant = 0
  while vs.any? { |v| !v } # haya nodos sin visitar
    vs[s] = true
    marcar_alcanzables(gl, s, vs)
    cant += 1 # una componente más
    s = vs.index(false) # próximo sin visitar aún
  end
  cant
end

def marcar_alcanzables(gl, s, vs)
  gl[s].each do |v|
    return if vs[v]
    vs[v] = true
    marcar_alcanzables(gl, v, vs)
  end
end

puts cantidad_de_componentes_conexas([[], [], []]) # 3
puts cantidad_de_componentes_conexas([[1], [0], []]) # 2
puts cantidad_de_componentes_conexas([[1,2], [0,2], [0,1]]) # 1

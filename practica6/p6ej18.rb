def cantidad_de_caminos(gl, v, w)
  # denota cuántos caminos hay desde el vértice v hasta el vértice w
  # en el grafo gl, que está representado con una lista de adyacencias.
  # PRECONDICIÓN: asume que el grafo no tiene ciclos.
  resultado = 0
  gl[v].each do |n|
    resultado += 1 if n == w                   # si ya llegué a w
    resultado += cantidad_de_caminos(gl, n, w) # busco otras formas de llegar a w
  end
  resultado
end

gl = [
    [1,2,3],
    [2,5],
    [4],
    [4],
    [5],
    [],
    []
]

puts cantidad_de_caminos(gl, 0, 5) == 4
puts cantidad_de_caminos(gl, 0, 2) == 2
puts cantidad_de_caminos(gl, 0, 4) == 3
puts cantidad_de_caminos(gl, 0, 4) == 3
puts cantidad_de_caminos(gl, 0, 6) == 0
puts cantidad_de_caminos(gl, 0, 3) == 1
puts cantidad_de_caminos(gl, 0, 2) == 2

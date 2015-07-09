def prim(g)
  a = grafo_del_mismo_tamaño_que(g)
  vs = lista_de_visitados_para(g)
  visitar(vs, 0)
  while cantidad_de_vertices(g) - 1 > cantidad_de_aristas(a) # o también... haya alguno sin visitar

    potenciales_aristas = []
    for i in 0..cantidad_de_vertices(g)-1
      for j in 0..cantidad_de_vertices(g)-1
        if g[i][j] && vs[i] && !vs[j]
          potenciales_aristas << [i, j, g[i][j]]
        end
      end
    end
    potenciales_aristas = potenciales_aristas.sort_by { |e| e[2] }
    arista_elegida = potenciales_aristas.first

    agregar_arista(a, arista_elegida)
    visitar(vs, arista_elegida[1]) # visito el vértice con el que me conecta esa arista
  end
  a
end

def cantidad_de_vertices(g)
  g.length
end

def cantidad_de_aristas(g)
  count = 0
  for i in 0..cantidad_de_vertices(g)-1
    for j in 0..cantidad_de_vertices(g)-1
      count += 1 if g[i][j]
    end
  end
  count
end

def lista_de_visitados_para(g)
  [false] * cantidad_de_vertices(g)
end

def visitar(vs, i)
  vs[i] = true
end

def agregar_arista(g, a)
  g[a[0]][a[1]] = a[2]
end

def grafo_del_mismo_tamaño_que(g)
  a = []
  for i in 0..cantidad_de_vertices(g)-1
    a[i] = []
    for j in 0..cantidad_de_vertices(g)-1
      a[i][j] = nil
    end
  end
  a
end

def kruskal(g)

end

# ejemplo ejercicio 5
_ = nil
puts prim([
  [_, 3, _, _, 3, _, _, _],
  [3, _, 2, _, 3, _, 2, _],
  [_, 2, _, 4, _, _, 2, _],
  [_, _, 4, _, _, 6, _, 6],
  [3, 3, _, _, _, 5, 4, _],
  [_, _, _, 6, 5, _, 1, 6],
  [_, 2, 2, _, 4, 1, _, 7],
  [_, _, _, 6, _, 6, 7, _]
]).to_s

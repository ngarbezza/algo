def dijkstra(g)
  inf = Float::INFINITY
  distancias = [0] + [inf] * (g.length-1)
  procesados = [nil] * g.length
  sin_procesar = Array(0..g.length-1)

  until sin_procesar.empty?

    # TODO: mejorar utilizando colas de prioridad
    vertice_con_distancia_minima = nil
    distancia_minima = inf
    sin_procesar.each do |v|
      if distancias[v] < distancia_minima
        distancia_minima = distancias[v]
        vertice_con_distancia_minima = v
      end
    end

    g[vertice_con_distancia_minima].each_with_index do |u, i|
      if u
        nueva_distancia_a_u = distancias[vertice_con_distancia_minima] + u
        if nueva_distancia_a_u < distancias[i]
          distancias[i] = nueva_distancia_a_u
          procesados[i] = vertice_con_distancia_minima
        end
      end
    end

    sin_procesar.delete vertice_con_distancia_minima

  end

  [procesados, distancias]
end

def floyd(g)
  d = g.clone
  (0..g.length-1).each do |i|
    (0..g.length-1).each do |j|
      (0..g.length-1).each do |k|
        if d[i][k] + d[k][j] < d[i][j]
          d[i][j] = d[i][k] + d[k][j]
        end
      end
    end
  end
  d
end

# ejemplo ejercicio 6
# _ = nil
# puts dijkstra([
#     [_, 4, 7, _, _, 3],
#     [_, _, 3, _, 2, _],
#     [_, _, _, 2, 1, _],
#     [_, _, _, _, _, _],
#     [_, _, _, 2, _, _],
#     [_, _, _, _, 3, _]
# ]).to_s


_ = nil
puts dijkstra([
    [_, 1, 4, _],
    [_, _, 2, 9],
    [_, _, _, 1],
    [_, _, _, _]
]).to_s

x = Float::INFINITY
puts floyd([
    [0, 1, 4, x],
    [x, 0, 2, 9],
    [x, x, 0, 1],
    [x, x, x, 0]
]).to_s

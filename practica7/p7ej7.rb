def dijkstra(g)
  inf = Float::INFINITY
  distancias = [0] + [inf] * (g.length-1)
  procesados = [nil] * g.length
  sin_procesar = Array(0..g.length-1)

  until sin_procesar.empty?

    # TODO: mejorar utilizando colas de prioridad
    min_v = nil
    min_d = inf
    sin_procesar.each do |v|
      if distancias[v] < min_d
        min_d = distancias[v]
        min_v = v
      end
    end

    g[min_v].each_with_index do |u, i|
      if u
        nueva_distancia_a_u = distancias[min_v] + u
        if nueva_distancia_a_u < distancias[i]
          distancias[i] = nueva_distancia_a_u
          procesados[i] = min_v
        end
      end
    end

    sin_procesar.delete min_v

  end

  [procesados, distancias]
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
    [_, _, 2, _],
    [_, _, _, 1],
    [_, _, _, 9]
]).to_s

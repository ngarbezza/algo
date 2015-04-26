require_relative '../extensions/array'

def partes_de(conjunto)
  return [[]] if conjunto.empty?

  partes_restantes = partes_de(conjunto.tail)
  partes_con_elemento_actual = partes_restantes.map{ |p| p + [conjunto.first] }
  partes_restantes + partes_con_elemento_actual
end

def partes_n_bits(conjunto)
  # partes_de(conjunto) tiene 2^n elementos
  (0..(2**conjunto.length)-1).map { |i| i.to_s(2) }
end

def mochila(w, ws, gs)
  mochila_aux 0, 0, w, ws, gs
end

def mochila_aux(wt, gt, w, ws, gs)
  #
  # problema de la mochila, con backtracking
  #
  # wt:   peso hasta el momento
  # gt:   ganancia hasta el momento
  # w:    peso total de la mochila
  # ws:   pesos de las cosas que aún puedo poner
  # gs:   ganancias de las cosas que aún puedo poner
  #
  return gt if gs.empty? # llenamos la mochila

  res = gt  # la mejor ganancia hasta el momento
  for i in 0..gs.length-1
    new_w = wt + ws[i]
    if new_w <= w # es solución factible (puedo poner el elemento en la mochila)
      res = [res, mochila_aux(new_w, gt + gs[i], w, ws.without_elem_at(i), gs.without_elem_at(i))].max
    end
  end
  res
end

puts partes_de([1,2,3,4]).to_s
puts partes_n_bits([1,2,3,4]).to_s

# en este caso me conviene poner los dos que pesan 5 (21 en total)
puts mochila(10, [10, 5, 5, 20], [5, 20, 1, 50])

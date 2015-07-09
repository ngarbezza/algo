require_relative '../extensions/array'

def permutaciones_de(lista)
  return [[]] if lista.empty?

  resultado = []
  for i in 0..lista.length-1
    permutaciones_del_resto = permutaciones_de(lista.without_elem_at(i))
    resultado += permutaciones_del_resto.map { |perm| [lista[i]] + perm }
  end

  resultado
end

def viajante(ciudades, distancias)
  resultado = ciudades
  permutaciones_de(ciudades).each do |permutacion|
    if distancia_total(permutacion, distancias) < distancia_total(resultado, distancias)
      resultado = permutacion
    end
  end
  resultado
end

def distancia_total(solucion, distancias)
  distancia = 0
  for i in 1..solucion.length-1
    distancia += distancia_entre(solucion[i-1], solucion[i], distancias)
  end
  distancia
end

def distancia_entre(un_lugar, otro_lugar, distancias)
  distancia = distancias.detect do |dist|
    (dist[0] == un_lugar && dist[1] == otro_lugar) || (dist[1] == un_lugar && dist[0] == otro_lugar)
  end
  distancia[2]
end

# [1,2,3], [1,3,2], [2,1,3], [2,3,1], [3,2,1], [3,1,2]
puts permutaciones_de([1,2,3]).to_s

# [:bernal, :quilmes, :berazategui, :hudson]
puts viajante([:quilmes, :berazategui, :bernal, :hudson],
              [[:hudson, :berazategui, 10],
               [:hudson, :quilmes, 17],
               [:hudson, :bernal, 25],
               [:berazategui, :quilmes, 8],
               [:berazategui, :bernal, 12],
               [:quilmes, :bernal, 3]]).to_s

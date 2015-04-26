def matriz_potencia_hasta(a, n)
  if (n == 1)
    return potencia(a, 1)
  else
    indice_medio = n / 2
    mitad_calculada = matriz_potencia_hasta(a, indice_medio)
    return mitad_calculada + mitad_calculada * potencia(a, indice_medio)
  end
end

def potencia(a, n)
  puts "me han llamado"
  a ** n
end

puts matriz_potencia_hasta(3, 16)

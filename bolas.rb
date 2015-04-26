# def mas_liviana(bolas)
#   bolas_a_pesar = bolas
#   mas_liviana = nil
#   if bolas.length.odd?
#     # dejamos un número par de bolas para poder dividirlas en
#     # mitades y pesarlas correctamente
#     bolas_a_pesar = bolas.drop(bolas.length - 1)
#   end
#   while !mas_liviana
#     mitad = bolas_a_pesar.length / 2
#     primera_mitad = bolas_a_pesar.take(mitad)
#     segunda_mitad = bolas_a_pesar.drop(mitad)
#     peso = pesar(primera_mitad, segunda_mitad)
#     if (peso == 0)
#       # si se asume que siempre hay exactamente una bola más liviana
#       # que el resto, entonces esto sólo ocurre cuando la cantidad
#       # de bolas es impar y la primera, que fue separada del resto,
#       # es necesariamente la más liviana.
#       mas_liviana = bolas.first
#     elsif (peso == 1)
#       if primera_mitad.length == 1
#         mas_liviana = primera_mitad.first
#       else
#         bolas_a_pesar = primera_mitad
#       end
#     else
#       if segunda_mitad.length == 1
#         mas_liviana = segunda_mitad.first
#       else
#         bolas_a_pesar = segunda_mitad
#       end
#     end
#   end
#   mas_liviana
# end

def mas_liviana(bolas)
  if bolas.length.odd?
    bolas_a_pesar = bolas.drop(1)
  else
    bolas_a_pesar = bolas
  end
  mitad = bolas_a_pesar.length / 2
  primera_mitad = bolas_a_pesar.take(mitad)
  segunda_mitad = bolas_a_pesar.drop(mitad)
  peso = pesar(primera_mitad, segunda_mitad)
  return bolas.first if peso == 0
  if bolas_a_pesar.length == 2
    if (peso == 1)
      bolas_a_pesar[0]
    else
      bolas_a_pesar[1]
    end
  else
    if (peso == 1)
      mas_liviana(primera_mitad)
    else
      mas_liviana(segunda_mitad)
    end
  end
end

def pesar(unas_bolas, otras_bolas)
  otras_bolas.map(&:peso).inject(&:+) <=> unas_bolas.map(&:peso).inject(&:+)
end

Bola = Struct.new 'Bola', :numero, :peso
bolas = [
  Bola.new(1, 3),
  Bola.new(2, 3),
  Bola.new(3, 3),
  Bola.new(4, 3),
  Bola.new(5, 3),
  Bola.new(6, 2)
]

puts mas_liviana(bolas)

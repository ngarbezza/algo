require_relative '../tsp'
require 'nokogiri'

def ejemplo_4(algoritmo)
  # resultado óptimo esperado:
  #
  #  recorrido: 0 -> 1 -> 2 -> 3 -> 0
  #  distancia: 6
  #
  tsp algoritmo, 4, 0, matriz_de_distancias(4)
end

def ejemplo_5(algoritmo)
  # resultado óptimo esperado:
  #
  #  recorrido: 0 -> 2 -> 1 -> 4 -> 3 -> 0
  #  distancia: 19
  #
  tsp algoritmo, 5, 0, matriz_de_distancias(5)
end

def ejemplo_6(algoritmo)
  # resultado óptimo esperado:
  #
  #  recorrido: 0 -> 2 -> 1 -> 4 -> 3 -> -> 5 -> 0
  #  distancia: 15
  #
  tsp algoritmo, 6, 0, matriz_de_distancias(6)
end

def ejemplo_11(algoritmo)
  # resultado óptimo esperado:
  #
  #  recorrido: 0 -> 7 -> 4 -> 3 -> 9 -> 5 -> 2 -> 6 -> 1 -> 10 -> 8 -> 0
  #  distancia: 253
  #
  tsp algoritmo, 11, 0, matriz_de_distancias(11)
end

def ejemplo_16(algoritmo)
  # resultado óptimo esperado:
  #
  #  recorrido: 0 -> 13 -> 12 -> 11 -> 6 -> 5 -> 14 -> 4 -> 10 -> 8 -> 9 -> 15 -> 2 -> 1 -> 3 -> 7 -> 0
  #  distancia: 6859
  #
  tsp algoritmo, 16, 0, matriz_de_distancias(16)
end

def ejemplo_22(algoritmo)
  # resultado óptimo esperado:
  #
  #  recorrido: 0 -> 13 -> 12 -> 11 -> 6 -> 5 -> 14 -> 4 -> 10 -> 8 -> 9 -> 18 -> 19 -> 20 -> 15 -> 2 -> 1 -> 16 -> 21 -> 3 -> 17 -> 7 -> 0
  #  distancia: 7013
  #
  tsp algoritmo, 22, 0, matriz_de_distancias(22)
end

CARPETA_EJEMPLOS = 'ejemplos'

def matriz_de_distancias(numero_de_ejemplo)
  leer_instancia "#{CARPETA_EJEMPLOS}/#{numero_de_ejemplo}"
end

def leer_instancia(ejemplo)
  File.readlines(ejemplo).map { |line| line.split(/\W+/).map(&:to_i) }
end

def leer_instancia_xml(ejemplo)
  file = File.open("#{CARPETA_EJEMPLOS}/#{ejemplo}")
  doc = Nokogiri::XML(file)
  vertices = doc.xpath('//graph/vertex')
  matriz = []
  vertices.each_with_index do |elem, index|
    matriz << [0] * vertices.length
    elem.xpath('edge').each do |edge|
      cost_to_parse = edge.attribute('cost').to_s
      cost = '%g' % ('%.2f' % cost_to_parse)
      matriz[index][edge.content.to_i] = cost.to_i
    end
  end
  file.close
  matriz
end

def escribir_matriz(matriz, nombre_archivo)
  archivo_destino = "#{CARPETA_EJEMPLOS}/#{nombre_archivo}"
  open(archivo_destino, 'w') do |archivo|
    matriz.each do |fila|
      archivo.puts fila.join(' ')
    end
  end
end

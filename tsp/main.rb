require_relative 'ejemplos/ejemplos'
require_relative 'implementaciones/hungarian'
require 'benchmark'

# ejemplo = 11
# bb = BranchAndBoundTSP.new(ejemplo, matriz_de_distancias(ejemplo))
# sol = bb.resolver
# puts sol.to_s

ejemplo = 11
bb = BranchAndBoundTSP.new(ejemplo, matriz_de_distancias(ejemplo))
sol = nil
puts Benchmark.measure { sol = bb.resolver }
puts sol.to_s

# Generar matriz desde TSPLIB xml
#
# ma = leer_instancia_xml('ALL_tsp/ulysses16/ulysses16.xml')
#
# escribir_matriz(ma, '16')


## Testeando algoritmo hungaro
#
# ejemplo = 11
# md = matriz_de_distancias(ejemplo)
# for i in 0..ejemplo-1
#   for j in 0..ejemplo-1
#     md[i][j] = Float::INFINITY if md[i][j] == 0
#   end
# end
# m = HungarianAlgorithm.new(md.map(&:clone))
# resultado = m.find_pairings
# p resultado
#
# dist = 0
# resultado.each do |pair|
#   dist += md[pair[0]][pair[1]]
# end
# p dist

# ejemplo = 16
# bb = BranchAndBoundTSP.new(ejemplo, matriz_de_distancias(ejemplo))
# p bb.cota_inferior(bb.nodo_inicial)
# p bb.cota_inferior_hungara(bb.nodo_inicial)

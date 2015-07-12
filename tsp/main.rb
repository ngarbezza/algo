require_relative 'ejemplos/ejemplos'
require 'benchmark'

# ejemplo = 6
# bb = BranchAndBoundTSP.new(ejemplo, matriz_de_distancias(ejemplo))
# sol = nil
# sol = bb.resolver
# puts sol.to_s

ejemplo = 16
bb = BranchAndBoundTSP.new(ejemplo, matriz_de_distancias(ejemplo))
sol = nil
puts Benchmark.measure { sol = bb.resolver }
puts sol.to_s

# Generar matriz desde TSPLIB xml
#
# ma = leer_instancia_xml('ALL_tsp/ulysses16/ulysses16.xml')
#
# escribir_matriz(ma, '16')

require_relative 'ejemplos/ejemplos'
require 'benchmark'

# ejemplo = 6
# bb = BranchAndBoundTSP.new(ejemplo, matriz_de_distancias(ejemplo))
# sol = nil
# sol = bb.resolver
# puts sol.to_s

ejemplo = 11
bb = BranchAndBoundTSP.new(ejemplo, matriz_de_distancias(ejemplo))
sol = nil
puts Benchmark.measure { sol = bb.resolver }
puts sol.to_s

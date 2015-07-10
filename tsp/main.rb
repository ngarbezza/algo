require_relative 'ejemplos/ejemplos'

ejemplo = 11

bb = BranchAndBoundTSP.new(ejemplo, matriz_de_distancias(ejemplo))

sol = bb.resolver

puts sol.to_s

require_relative 'ejemplos/ejemplos'
require_relative 'implementaciones/hungarian'
require 'benchmark'

ejemplo = 11

calculador_de_cota_inferior = SumaDeDosEjesConMenorPesoPorCadaVertice

calculador_de_cota_superior = VecinoMasCercano
# calculador_de_cota_inferior = AlgoritmoHungaro

# log_salida = true
log_salida = false

bb = BranchAndBoundTSP.new(ejemplo,
                           matriz_de_distancias(ejemplo),
                           calculador_de_cota_inferior,
                           calculador_de_cota_superior,
                           log_salida)

# Para correr con benchmark
Benchmark.measure { solucion = bb.resolver; puts solucion.to_s }
# Para correr sin benchmark
# solucion = bb.resolver; puts solucion.to_s


# Generar matriz desde TSPLIB xml
#
# ma = leer_instancia_xml('ALL_tsp/ulysses16/ulysses16.xml')
#
# escribir_matriz(ma, '16')

# ejemplo = 16
# bb = BranchAndBoundTSP.new(ejemplo, matriz_de_distancias(ejemplo))
# p bb.cota_inferior(bb.nodo_inicial)
# p bb.cota_inferior_hungara(bb.nodo_inicial)

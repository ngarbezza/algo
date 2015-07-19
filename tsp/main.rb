require_relative 'ejemplos/ejemplos'
require_relative 'implementaciones/hungarian'
require 'benchmark'

# Ejemplos disponibles: 5, 6, 11, 16, 22
ejemplo = 11

configuracion = {
    # calculador_de_cota_inferior: AlgoritmoHungaro,
    calculador_de_cota_inferior: SumaDeDosEjesConMenorPesoPorCadaVertice,
    calculador_de_cota_superior: VecinoMasCercano,
    # log_salida: true,
    log_salida: false,
}

branch_and_bound = BranchAndBoundTSP.new(matriz_de_distancias(ejemplo), configuracion)

# Para correr con benchmark
# Benchmark.measure { solucion = branch_and_bound.resolver; puts solucion.to_s }
# Para correr sin benchmark
solucion = branch_and_bound.resolver; puts solucion.to_s

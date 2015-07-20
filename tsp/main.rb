require_relative 'ejemplos/ejemplos'
require_relative 'implementaciones/hungarian'
require 'benchmark'

# Ejemplos disponibles: 5, 6, 11, 16, 22
ejemplo = 16

configuracion = {

    # El algoritmo a utilizar para la cota inferior. Elegir uno
    calculador_de_cota_inferior: AlgoritmoHungaro,
    # calculador_de_cota_inferior: SumaDeDosEjesConMenorPesoPorCadaVertice,

    # El algoritmo a utilizar para la cota superior. Actualmente sólo esta opción.
    calculador_de_cota_superior: VecinoMasCercano,

    # true si queremos ver output de consola (aumenta un 10% del tiempo de ejecución aprox.), false si no
    log_salida: true,
    # log_salida: false,

    # Para elegir en qué orden procesar los nodos.
    # procesar_ultimos_nodos_primero: true,
    procesar_ultimos_nodos_primero: false,

    # Para elegir si procesar la rama izquierda primero o no.
    procesar_rama_izquierda_primero: true,
    # procesar_rama_izquierda_primero: false,

    # Para elegir si procesar los nodos al azar o no (invalida las dos opciones anteriores)
    procesar_nodos_al_azar: false,
    # procesar_nodos_al_azar: true,
}

branch_and_bound = BranchAndBoundTSP.new(matriz_de_distancias(ejemplo), configuracion)

# Para correr con benchmark
# Benchmark.measure { solucion = branch_and_bound.resolver; puts solucion.to_s }
# Para correr sin benchmark
solucion = branch_and_bound.resolver; puts solucion.to_s

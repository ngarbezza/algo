require_relative 'ejemplos/ejemplos'

# Generar matriz desde TSPLIB xml
#
ma = leer_instancia_xml('ALL_tsp/ulysses22/ulysses22.xml')
escribir_matriz(ma, '22')

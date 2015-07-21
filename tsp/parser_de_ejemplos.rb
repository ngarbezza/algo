require_relative 'ejemplos/ejemplos'

# Generar matriz desde TSPLIB xml
#
ma = leer_instancia_xml('ALL_tsp/bayg29/bayg29.xml')
escribir_matriz(ma, '29')

require_relative '../aux'
require_relative 'restricciones_tsp'

### Invariante de las restricciones
# para X cantidad de ciudades
#  * un eje i,j no puede estar en los dos tipos de restricciones al mismo tiempo
#  * la ciudad i puede aparecer solo dos veces dentro de las restricciones de tipo 'tiene que estar'
#  * si aparece dos veces, entonces tiene que aparecer X-2 veces en las restricciones de tipo 'no tiene que estar'

### COTA INFERIOR

def cota_inferior(cantidad_de_ciudades, distancias, restricciones)
  total = 0
  (0..cantidad_de_ciudades-1).each do |i|
    primer_eje_elegido = Float::INFINITY
    primer_eje_elegido_por_ser_minimo = true
    segundo_eje_elegido = Float::INFINITY
    segundo_eje_elegido_por_ser_minimo = true

    (0..cantidad_de_ciudades-1).each do |j|
      if restricciones.tiene_que_estar?(i, j)
        if primer_eje_elegido_por_ser_minimo
          segundo_eje_elegido = primer_eje_elegido # lo muevo de lugar para que entre el que tiene que estar sí o sí
          primer_eje_elegido = costo_en_llegar_a(i, j, distancias)
          primer_eje_elegido_por_ser_minimo = false
        elsif segundo_eje_elegido_por_ser_minimo
          segundo_eje_elegido = costo_en_llegar_a(i, j, distancias)
          segundo_eje_elegido_por_ser_minimo = false
        else
          raise 'error en las definiciones de restricciones del TSP: no puede haber más de 2 ejes incidentes a un mismo vértice'
        end
      elsif i == j
        # nada que hacer
      elsif restricciones.no_tiene_que_estar?(i, j)
        # nada que hacer
      elsif !primer_eje_elegido_por_ser_minimo && !segundo_eje_elegido_por_ser_minimo
        # nada que hacer
      else
        current = costo_en_llegar_a(i, j, distancias)
        if current < primer_eje_elegido && primer_eje_elegido_por_ser_minimo
          segundo_eje_elegido = primer_eje_elegido
          primer_eje_elegido = current
        elsif current < segundo_eje_elegido && segundo_eje_elegido_por_ser_minimo
          segundo_eje_elegido = current
        end
      end

    end
    total += primer_eje_elegido
    total += segundo_eje_elegido
  end
  total.fdiv(2)
end

### COTA SUPERIOR

def cota_superior(cantidad_de_ciudades, distancias, restricciones)
  # TODO: considerar restricciones
  Float::INFINITY
  # greedy(cantidad_de_ciudades, 0, distancias)[1]
end

### BRANCH AND BOUND

def branch_and_bound(cantidad_de_ciudades, ciudad_inicial, distancias)
  nodos = []
  nodos << nodo_inicial(cantidad_de_ciudades, distancias)
  nodo_actual = proximo_nodo_a_procesar(nodos)
  until encontre_solucion_optima?(nodo_actual)
    # dividir nodo_actual
    branchear(nodo_actual, nodos, cantidad_de_ciudades)
    nodo_actual = proximo_nodo_a_procesar(nodos)
    # avisar a ancestros
    # podar si se puede
  end
end

def branchear(nodo, nodos, cantidad_de_ciudades)
  nueva_restriccion = buscar_nueva_restriccion_para_branchear(nodo[:restricciones])
  branch_izquierdo = {
      padre: nodo,
      restricciones: con_restricciones_inferidas_al_incluir(nueva_restriccion, nodo[:restricciones])
  }
  branch_derecho = {
      padre: nodo,
      restricciones: con_restricciones_inferidas_al_excluir(nueva_restriccion, nodo[:restricciones])
  }
  nodos << branch_izquierdo
  nodos << branch_derecho
end

def proximo_nodo_a_procesar(nodos)
  nodos.first
end

def encontre_solucion_optima?(nodo)
  nodo[:cota_superior] == nodo[:cota_inferior]
end

def nodo_inicial(cantidad_de_ciudades, distancias)
  {padre: nil,
   restricciones: [],
   cota_inferior: cota_inferior(cantidad_de_ciudades, distancias, []),
   cota_superior: cota_superior(cantidad_de_ciudades, distancias, [])}
end

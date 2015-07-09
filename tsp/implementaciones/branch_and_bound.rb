require_relative 'aux'

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
      if tiene_que_estar?(i, j, restricciones)
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
      elsif no_tiene_que_estar?(i, j, restricciones)
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

# TODO: mover a una matriz de restricciones

def tiene_que_estar?(desde, hasta, restricciones)
  restricciones[:ejes_que_tienen_que_estar].any? { |r| r == [desde, hasta] || r == [hasta, desde] }
end

def no_tiene_que_estar?(desde, hasta, restricciones)
  restricciones[:ejes_que_no_tienen_que_estar].any? { |r| r == [desde, hasta] || r == [hasta, desde] }
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

def buscar_nueva_restriccion_para_branchear(restricciones)
  # precondición: asume que las restricciones del nodo satisfacen el invariante
  cantidad_de_ciudades = restricciones.length
  (0..cantidad_de_ciudades-1).each do |i|
    (0..cantidad_de_ciudades-1).each do |j|
      return [i, j] if restricciones[i][j] == 0
    end
  end

  raise 'ya existen todas las restricciones posibles'
end

def con_restricciones_inferidas_al_incluir(una_restriccion, restricciones)
  # agregar restricción
  restricciones[una_restriccion[0]][una_restriccion[1]] = 1
  restricciones[una_restriccion[1]][una_restriccion[0]] = 1

  # ver si no hace falta más de exclusión (para mantener 2 ejes incidentes siempre)
  cantidad_de_ciudades = restricciones.length
  (0..cantidad_de_ciudades-1).each do |i|
    if restricciones[i].count(1) == 2 # dos adyacentes
      (0..cantidad_de_ciudades-1).each do |j|
        if restricciones[i][j] == 0
          restricciones[i][j] = -1
          restricciones[j][i] = -1
        end
      end
    end
  end
  # ver si no hace falta más de exclusión (para que no haya ciclos prematuros)
  (0..cantidad_de_ciudades-1).each do |i|
    (0..cantidad_de_ciudades-1).each do |j|
      if restricciones[i][j] == 0
        restricciones[i][j] = 1
        restricciones[j][i] = 1
        if hay_ciclo_que_no_forma_tour?(restricciones, cantidad_de_ciudades)
          restricciones[i][j] = -1
          restricciones[j][i] = -1
        else
          restricciones[i][j] = 0
          restricciones[j][i] = 0
        end
      end
    end
  end

  # ver si no hace falta más de inclusión
  (0..cantidad_de_ciudades-1).each do |i|
    ceros = restricciones[i].count(0)
    unos = restricciones[i].count(0)
    if (ceros == 2 && unos == 0) || (ceros == 1 && unos == 1)
      (0..cantidad_de_ciudades-1).each do |j|
        if restricciones[i][j] == 0
          restricciones[i][j] = 1
          restricciones[j][i] = 1
        end
      end
    end
  end

  restricciones
end

def hay_ciclo_que_no_forma_tour?(restricciones, cantidad_de_ciudades)
  hay_ciclo?(restricciones) && (0..cantidad_de_ciudades-1).any? { |c| restricciones[c].count(1) != 2 }
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

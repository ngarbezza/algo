require_relative 'aux'

def calcular_cota_inferior(cantidad_de_ciudades, distancias, restricciones)
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

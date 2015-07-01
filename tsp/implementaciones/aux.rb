# Definiciones auxiliares

def costo_en_llegar_a(una_ciudad, ciudad_anterior, distancias)
  return 0 if ciudad_anterior.nil?
  distancias[una_ciudad][ciudad_anterior]
end

def debe_terminar_recorrido?(un_recorrido)
  un_recorrido.last != un_recorrido.first
end

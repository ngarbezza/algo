def transform_r(u, v)
  return 0 if u == v

  u_b = u.slice 0, u.length - 1
  v_b = v.slice 0, v.length - 1
  change_cost = u[-1] == v[-1] ? 0 : 1

  ops = []
  ops << (1 + transform_r(u_b, v)) if u_b
  ops << (1 + transform_r(u, v_b)) if v_b
  ops << (change_cost + transform_r(u_b, v_b)) if u_b && v_b

  ops.min
end

def transform_dp(u, v)
  #
  # matriz de u+1 filas y v+1 columnas para ir guardando
  # todos los resultados de las transformaciones parciales
  #
  # en cada elemento tenemos la lista de operaciones que
  # debemos hacer para llegar de u[i] a u[v]
  #
  # las operaciones pueden ser
  #   * [:add, 'a', 3] (agregar 'a' en la posición 3 de u)
  #   * [:remove, 'b', 6] (remover 'b' de la posición 6 de u)
  #   * [:replace, 'a', 'b', 2] (reemplazar 'a' por 'b' en la posición 2 de u)
  #
  res = Array.new(u.length)
  for i in 0..u.length
    res[i] = [nil] * v.length
  end

  # si los dos strings fuesen vacíos, no hay cambios que hacer
  res[0][0] = []

  for i in 1..u.length
    # necesito remover i caracteres para llegar de u a v
    res[i][0] = res[i-1][0] + [[:remove, u[i-1], i]]
  end

  for j in 1..v.length
     # necesito agregar i caracteres para llegar de u a v
    res[0][j] = res[0][j-1] + [[:add, v[j-1], j]]
  end

  for i in 1..u.length
    for j in 1..v.length
      
      addition = 1 + res[i-1][j].length
      deletion = 1 + res[i][j-1].length
      cost = u[i] == v[j] ? 0 : 1 # tengo que reemplazar o no
      substitution = cost + res[i-1][j-1].length

      if (addition < deletion && addition < substitution)
        # nos conviene agregar
        res[i][j] = res[i-1][j] + [[:add, v[j-1], i]]
      elsif (deletion < addition && deletion < substitution)
        # nos conviene borrar
        res[i][j] = res[i][j-1] + [[:remove, u[i-1], i]]
      else
        if cost == 0
          # no tenemos que hacer nada
          res[i][j] = res[i-1][j-1]
        else
          # nos conviene reemplazar
          res[i][j] = res[i-1][j-1] + [[:replace, u[i], v[j], i+1]]
        end
      end
    end
  end

  final_result = res[u.length][v.length]
  "#{final_result.length} changes: #{final_result}"
end


# prueba: versión recursiva
# puts transform_r('abbac', 'abcbc').to_s


# prueba: versión con dynamic programming
puts transform_dp('abbac', 'abcbc')
puts transform_dp('', 'hola')

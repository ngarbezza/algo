def mergesort(xs)
  return [xs, 0] if xs.length <= 1
  
  mindex = xs.length / 2
  left = mergesort(xs.take(mindex))
  right = mergesort(xs.drop(mindex))

  merge(left, right)
end

# def merge(left_result, right_result)
#   left = left_result[0]
#   right = right_result[0]
#   result = []
#   unordered = 0
#   puts "merging #{left} with #{right}"
#   while !left.empty? and !right.empty?
#     if left.first <= right.first
#       result << left.first
#       left = left.drop(1)
#     else
#       unordered += left.length
#       result << right.first
#       right = right.drop(1)
#     end
#   end
#   result += left unless left.empty?
#   result += right unless right.empty?

#   [result, unordered + left_result[1] + right_result[1]]
# end

def parejas_en_desorden(xs)
  parejas_en_desorden_aux(xs)[1]
end

def parejas_en_desorden_aux(xs)
  return [xs, 0] if xs.length <= 1
  
  middle_index = xs.length / 2
  left = parejas_en_desorden_aux(xs.take(middle_index))
  right = parejas_en_desorden_aux(xs.drop(middle_index))

  merge(left, right)
end

def merge(left_result, right_result)
  left, right = left_result[0], right_result[0]
  result, unordered = [], 0
  while !left.empty? and !right.empty?
    if left.first <= right.first
      result << left.first
      left = left.drop(1)
    else
      # el elemento está desordenado respecto a todos los elementos
      # de la parte izquierda (sabemos que está desordenado respecto
      # del primero, y como el arreglo left está ordenado podemos
      # deducir que el elemento está desordenado respecto a todos
      # los elementos restantes.
      unordered += left.length
      result << right.first
      right = right.drop(1)
    end
  end
  result += left unless left.empty?
  result += right unless right.empty?
  total_unordered = unordered + left_result[1] + right_result[1]

  [result, total_unordered]
end

puts parejas_en_desorden([5, 4, 3, 2, 1])

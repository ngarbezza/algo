## Ejercicio 1

Implementación _naive_:

    def substring_match(pattern, text)
      n = text.size
      m = pattern.size
      for i in 0..n-m
        j = 0
        while j < m && text[i+j] == pattern[j]
          j += 1
        end
        return i if j == m
      end
      false
    end

Implementación en O(n) asumiendo que todos los caracteres del patrón son iguales: 

    def substring_match(pattern, text)
      n = text.size
      m = pattern.size
      match_index = 0
      for i in 0..n-1
        if match_index > 0 && text[i] == pattern[match_index]
          match_index += 1
        elsif text[i] == pattern[0]
          match_index = 1
        else
          match_index = 0
        end
        if match_index == m
          return i-m+1
        end
      end
      false
    end

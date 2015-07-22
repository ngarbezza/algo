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

text = 'abcccbabacaccc'

puts substring_match('a', text) == 0
puts substring_match('ba', text) == 5
puts substring_match('bac', text) == 7
puts substring_match('d', text) == false
puts substring_match('bca', text) == false

def primo?(n)
  a = 2
  es = true
  while n > a && es
    es = n % a != 0
    a += 1
  end
  return es
end

(1..100).each do |n|
  puts "primo #{n}: #{primo?(n)}"
end

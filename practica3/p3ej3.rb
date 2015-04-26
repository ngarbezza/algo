def ej3(m)
  x = m.length
  y = m[0].length

  r = Array.new(x)
  s = Array.new(x)
  for i in 0..x-1
    r[i] = Array.new(y)
    s[i] = Array.new(y)
    for j in 0..y-1
      r[i][j] = nil
      s[i][j] = nil
    end
  end

  r[0][0] = m[0][0]
  s[0][0] = 3

  for i in 1..x-1
    r[i][0] = r[i-1][0] + m[i][0]
    s[i][0] = [i-1, 0]
  end
  for j in 1..y-1
    r[0][j] = r[0][j-1] + m[0][j]
    s[0][j] = [0, j-1]
  end

  for i in 1..x-1
    for j in 1..y-1
      up = r[i-1][j]
      left = r[i][j-1]
      if up < left
        r[i][j] = up + m[i][j]
        s[i][j] = [i-1, j]
      else
        r[i][j] = left + m[i][j]
        s[i][j] = [i, j-1]
      end
    end
  end

  path = [[x-1, y-1]]
  i = s[x-1][y-1][0]
  j = s[x-1][y-1][1]
  path << s[x-1][y-1]
  while i > 0 || j > 0
    if s[i][j] != 3
      puts s[i][j].to_s
      path << s[i][j]
      i = s[i][j][0]
      j = s[i][j][1]
    end
  end
  
  puts path.to_s
end

m = [
  [2, 8, 3, 4],
  [5, 3, 4, 5],
  [1, 2, 2, 1],
  [3, 4, 6, 5]
]

ej3(m)

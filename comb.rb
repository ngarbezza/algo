def comb_r(n, k)
  return 1 if k == 0
  return 0 if n == 0

  comb(n-1, k) + comb(n-1, k-1)
end

def comb(n, k)
  a = []
  for i in 0..n
    a << [1] + [nil] * (k-1)
  end

  for j in 1..k
    a[0][j] = 0
  end

  for i in 1..n
    for j in 1..k
      a[i][j] = a[i-1][j] + a[i-1][j-1]
    end
  end

  return a[n][k]
end

puts comb(4,2).to_s

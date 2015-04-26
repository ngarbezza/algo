def matrix_min_path(a)
  m = a.length
  n = a[0].length
  results = a.clone
  results[0][0] = [[[0,0]], a[0][0]]
  for i in 1..m-1
    results[i][0] = [
      results[i-1][0][0] + [[i,0]],
      results[i-1][0][1] + a[i][0]
    ]
  end
  for j in 1..n-1
    results[0][j] = [
      results[0][j-1][0] + [[0, j]],
      results[0][j-1][1] + a[0][j]
    ]
  end
  for i in 1..m-1
    for j in 1..n-1
      if results[i-1][j][1] < results[i][j-1][1]
        results[i][j] = [
          results[i-1][j][0] + [[i,j]],
          results[i-1][j][1] + a[i][j]
        ]
      else
        results[i][j] = [
          results[i][j-1][0] + [[i,j]],
          results[i][j-1][1] + a[i][j]
        ]
      end
    end
  end
  results[m-1][n-1]
end

def matrix_min_path_optimized(a)
  m = a.length
  n = a[0].length
  results = [[[[]], aes]]
  results[0][0] = [[[0,0]], a[0][0]]
  for i in 1..m-1
    results[i][0] = [
      results[i-1][0][0] + [[i,0]],
      results[i-1][0][1] + a[i][0]
    ]
  end
  for j in 1..n-1
    results[0][j] = [
      results[0][j-1][0] + [[0, j]],
      results[0][j-1][1] + a[0][j]
    ]
  end
  for i in 1..m-1
    for j in 1..n-1
      if results[i-1][j][1] < results[i][j-1][1]
        results[i][j] = [
          results[i-1][j][0] + [[i,j]],
          results[i-1][j][1] + a[i][j]
        ]
      else
        results[i][j] = [
          results[i][j-1][0] + [[i,j]],
          results[i][j-1][1] + a[i][j]
        ]
      end
    end
  end
  results[m-1][n-1]
end
m = [[2,8,3,4],
     [5,3,4,5],
     [1,2,2,1],
     [3,4,6,5]]

puts matrix_min_path(m).to_s

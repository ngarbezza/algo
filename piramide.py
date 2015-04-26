def read(fileName):
  return [line.split() for line in open(fileName).readlines()]

def empty_cache(n):
  return [[-1]*(i+1) for i in xrange(0,n)]

""" Sol. recursiva ineficiente"""
def solve(P, i, j):
  if i == len(P) - 1:
    return P[i][j]
  else:
    return P[i][j] + max(solve(P,i+1,j),solve(P,i+1,j+1))

""" Caching de resultados, top down (MEMOIZATION) """
def solve(P, i, j, C):
  """ Si el valor para el nro el la pos. (i,j) fue computado antes, no repetir el trabajo"""
  if C[i][j] <> -1:
    return C[i][j]

  x = -1
  if i == len(P) - 1:
    x = P[i][j]
  else:
    x = P[i][j] + max(solve(P,i+1,j,C),solve(P,i+1,j+1,C))
  C[i][j] = x
  return x

""" Caching de resultados, bottom up (DYNAMIC PROGRAMMING) """
def solve_dp(P):
  a = [[-1]*(i+1) for i in xrange(0,len(P))]
  a[-1] = P[-1]
  for i in xrange(len(P)-2,-1,-1):
    for j in xrange(0,i+1):
      a[i][j] = P[i][j] + max(a[i+1][j], a[i+1][j+1])
  return a[0][0]

""" Misma solucion dynamic programming, pero minizando consumo de memoria """
def solve_dp1(P):
  a = P[-1][:]
  for i in xrange(len(P)-2,-1,-1):
    for j in xrange(0,i+1):
      a[j] = P[i][j] + max(a[j],a[j+1])
  return a[0]


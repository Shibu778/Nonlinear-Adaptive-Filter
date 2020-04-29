# Function for nonlinear adaptive filtering
import numpy as np
def nada(x,n,K):
  # Function for nonlinear adaptive filter
  # Reference: Tung, Wen-Wen & Gao, Jianbo & Hu, Jing & Yang, Lei. (2011). Detecting chaos in heavy-noise environments.
  # Code written by: Shibu Meher
  # x is the time series
  # n is the length of the segment taken
  # K is the order of the polynomial to be fitted
  # y is the filtered data
  Y = x

  ln_y = len(Y) # Length of time series Y
  t = [i for i in range(1,ln_y+1)]  # Creating an array to store time index

  m = int(ln_y/n)  # number of segment
  r = ln_y%n # Length of timeseries after remain which is less than n

  S = []
  op = []
  for i in range(1,m):
    S1 = []
    S1.append(Y[(i-1)*n:(i+1)*n+1])
    S1.append(t[(i-1)*n:(i+1)*n+1])
    S.append(S1)
    if i!=m-1:
      op1 = []
      op1.append(Y[i*n:(i+1)*n+1])
      op1.append(t[i*n:(i+1)*n+1])
      op.append(op1)

    if i == m-1:
      S1 = []
      S1.append(Y[i*n:(i+1)*n+r])
      S1.append(t[i*n:(i+1)*n+r])
      S.append(S1)
      op1 = []
      op1.append(Y[i*n:(i+1)*n+1])
      op1.append(t[i*n:(i+1)*n+1])
      op.append(op1)

  poly_S = []
  for i in range(0,len(S)):
    poly_S.append(np.polyfit(np.array(S[i][1]),np.array(S[i][0]),K))

  polyval_S = []
  for i in range(0,len(S)):
    polyval_S.append(np.polyval(poly_S[i],S[i][1]))

  l = [i for i in range(1,n+2)]
  w = []
  for i in range(0,n+1):
    w.append((l[i]-1)/n)  # Weight w1 varing from 1 to 0
  w = np.array(w)

  polyval_op = []
  for i in range(0,len(op)):
    polyval_op.append((1-w)*np.polyval(poly_S[i],op[i][1])+w*np.polyval(poly_S[i+1],op[i][1]))

  Y1 = np.array([])
  Y1 = np.concatenate((Y1,polyval_S[0][0:n+1]))
  for i in range(0,len(op)):
    Y1 = np.concatenate((Y1,polyval_op[i][0:-1]))
  Y1 = np.concatenate((Y1,polyval_S[len(S)-1][n+1:n+r+1]))
  return Y1

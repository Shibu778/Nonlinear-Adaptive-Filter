# This is a test program to run the Nonlinear adaptive filter algorithm
# Put the data file (denoising.xlsx) and function nada.py in the same folder along with it
# Go to the address bar in the folder and type cmd and put enter
# Command line will open
# Write python test.py in the command line and put enter
# Two figure will be ploted. But second one will appear after closing the first one.
# Make sure that you have the required library

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from nada import nada

df = pd.read_excel('denoising.xlsx')
x = np.array(df['MLD'])
Y1= nada(x,30,2)
plt.figure(1)
plt.plot(x,label = 'Raw signal')
plt.plot(Y1,label = 'Filtered signal')
plt.legend()
plt.show()

plt.figure(2)
plt.plot(x[0:1000],label = 'Raw signal')
plt.plot(Y1[0:1000],label = 'Filtered signal')
plt.legend()
plt.show()

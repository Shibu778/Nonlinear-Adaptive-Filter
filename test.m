% This is a test file to use nada.m with data of denoising.xlsx
filename = 'denoising.xlsx';
xlRange = 'A2:A12187';
x = xlsread(filename,xlRange);  % Reading data from the excel file
n = 30; % Parameter that will determine the length of the window
K = 2; % Degree of the polynomial fitted to the window

Y = nada(x,n,K); % Filtered timeseries by nonlinear adaptive filter
plot(x(1:1000));hold on;plot(Y(1:1000)) % Plotting the first 1000 points
% Parameter (n,K) determination for nonlinear adaptive filter
% K is the degree of polynomial to be fitted to a timeseries window of 2n+1
% How to choose n and K?
% Reference : Tung, Wen-Wen & Gao, Jianbo & Hu, Jing & Yang, Lei. (2011). Detecting chaos in heavy-noise environments
% Code by : Shibu Meher
clear;clc;
filename = 'denoising.xlsx';
xlRange = 'A2:A12187';
x = xlsread(filename,xlRange);

for K = 2:4
    i = 1;
    for n = 5:5:80
        Y = nada(x,n,K);
        var(i,K-1) = (sum((x-Y).^2))/length(x);
        w(i,K-1) = 2*n+1;
        i=i+1;
    end
end
figure;
plot(w(:,1),var(:,1));hold on;plot(w(:,2),var(:,2));plot(w(:,3),var(:,3));legend('K = 2','K = 3','K = 4');hold off;
figure(2)
xlabel('w')
ylabel('Variance')

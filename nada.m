function y = nada(x,n,K)
	% Function for nonlinear adaptive filter
    % Reference: Tung, Wen-Wen & Gao, Jianbo & Hu, Jing & Yang, Lei. (2011). Detecting chaos in heavy-noise environments.
    % Code written by : Shibu Meher
	% x is the time series
	% n is the length of the segment taken
	% K is the order of the polynomial to be fitted
	% y is the filtered data
    Y = x; % Time series data should be a single column
    if length(x(:,1))<2     %If time series data is a single row than convert it to column
        Y = Y';
    end
    ln_y = length(Y); % Length of time series Y
    t = (1:ln_y)';  % Creating an array to store time index
    %%  To get m1 as lower integer of m1 (m is number of segment)
    m1 = (ln_y/n);  
    if int16(m1)>m1
        m = int16(m1-1);
    else
        m = int16(m1);
    end
    m = double(m);
    r = rem(ln_y,n); % Number of points remained after dividing timeseries into m-1 segment
    %%
    S{m-1}=[];
    op{m-2} = [];
    for i = 1:m-1
        S{i} = [Y((i-1)*n+1:(i+1)*n+1) t((i-1)*n+1:(i+1)*n+1)]; % Storing the segments
        if i ~= m-1
            op{i} = [Y(i*n+1:(i+1)*n+1) t(i*n+1:(i+1)*n+1)];    % Storing the overlaping segment (op - overlapping)
        end
        if i==m-1
            S{i+1} = [Y((i)*n+1:(i+1)*n+r) t((i)*n+1:(i+1)*n+r)]; % Storing the last segment
            op{i} = [Y(i*n+1:(i+1)*n+1) t(i*n+1:(i+1)*n+1)];      % Storing the last overlaping segment
        end
    end
    poly_S{length(S)} = []; % Cell array to store fitted polynomial to each window
    for i = 1:length(S)
        ws = warning('off','all');  % Turn off warning
        poly_S{i} = polyfit(S{i}(:,2),S{i}(:,1),K);     % Fitting polynomial to each window using polyfit and storing the fitted parameter in poly_S
        warning(ws) 
    end
    
    polyval_S{length(S)} =[];       % Cell array to store the value fitted polynomial
    for i = 1:length(S)
        polyval_S{i} = polyval(poly_S{i},S{i}(:,2));    % Calculating the value of fitted polynomial and storing
    end
    
    l = (1:n+1)';   % Index for overlapping region
    w = zeros(n+1,2);   % array to store weight
    for i = 1:n+1
        w(i,1) = 1-(l(i)-1)/n;  % Weight w1 varing from 1 to 0
        w(i,2) = (l(i)-1)/n;    %Weight w2 varing from 0 to 1
    end
    
    polyval_op{length(op)} =[]; % Cell array to store weighted average value in overlapping region
    for i = 1:length(op)
        polyval_op{i} = w(:,1).*polyval(poly_S{i},op{i}(:,2),K)+w(:,2).*polyval(poly_S{i+1},op{i}(:,2),K); % Calculating weighted average for overlapping segment
    end
    % Try to preallocate Y1
    Y1 = zeros(length(Y),1);    % Array to store the filtered data
    Y1(1:n,1) = polyval_S{1}(1:n); % Storing the first unoverlapped filtered segment
    for i = 1:length(op)
        Y1(i*n+1:(i+1)*n,1) = polyval_op{i}(1:n);   % Storing the overlapped filter segment
    end
    Y1((length(op)+1)*n+1:end,1) = polyval_S{m}(n+1:n+r);   % Storing the last unoverlapped filter segment
    
    y = Y1;

end
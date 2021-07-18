clear;clc;

%% To observe flattening of curve for covid infections
% Data is taken from covid_19_india.csv

% Import data
covid = readtable('/MATLAB Drive/Term project 2020/Term project 2020/Dataset_Question3/covid_19_india.csv');
Date = datetime(covid.Date,"InputFormat",'dd/MM/uuuu');
Confirmed = covid.Confirmed;

% finding confirmed cases
formatIn = 'dd/mm/yyyy';
for i = 1:length(Date)
    if datenum(string(Date(i)),formatIn)>= datenum('01/03/0020',formatIn)
       break
    end
end
low = i;
for j = 1:length(Date)
    if datenum(string(Date(j)),formatIn)> datenum('10/04/0020',formatIn)
       break
    end
end
up = j-1;

X = datenum(string(Date(low:up,1)),formatIn,0020)-datenum('30/01/0020',formatIn,0020);
id = 1;
for i = 2:length(X)
    if X(i) ~= X(i-1) || i == length(X)
      net_confirmed(id,1) = sum(Confirmed(1:i-1,1));
      id = id +1;
    end
end

 X = unique(X);
 Y = net_confirmed;

 %% Fit: 'exponential fit' for entire data
    [xData, yData] = prepareCurveData( X, Y );
    
    % Set up fittype and options.
    ft = fittype( 'exp1' );
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.StartPoint = [0.230919425143269 0.17156136399375];
    
    % Fit model to data.
    [fitresult, gof] = fit( xData, yData, ft, opts );
    
    % Plot fit with data.
    figure( 'Name', 'exponential fit' );
    h = plot( fitresult, xData, yData );
    legend( h, 'Y vs. X', 'exponential fit', 'Location', 'NorthWest', 'Interpreter', 'none' );
    % Label axes
    xlabel( 'Day since first case', 'Interpreter', 'none' );
    ylabel( 'Net confirmed', 'Interpreter', 'none' );
    grid on
    txt = string(fitresult.a) + 'exp('+ string(fitresult.b) + 'x)';
    text(35,30000,txt);

% To observe flattening of the curve
% observing the nature of the graph at various intervals
X_sub1 = X(X<65);
Y_sub1 = Y(1:length(X_sub1));
 %% Fit: 'EXPONENTIAL FIT'.
    [xData1, yData1] = prepareCurveData( X_sub1, Y_sub1 );
    
    % Set up fittype and options.
    ft = fittype( 'exp1' );
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.StartPoint = [0.20007893759369 0.17443626896516];
    
    % Fit model to data.
    [fitresult1, gof] = fit( xData1, yData1, ft, opts );
    
    % Plot fit with data.
    figure( 'Name', 'EXPONENTIAL FIT' );
    h = plot( fitresult1, xData1, yData1 );
    legend( h, 'Y vs X(initial 65 days)', 'Exponential fit', 'Location', 'NorthWest', 'Interpreter', 'none' );
    % Label axes
    xlabel( 'Day since first case', 'Interpreter', 'none' );
    ylabel( 'Net confirmed', 'Interpreter', 'none' );
    grid on;
    txt1 =string(fitresult1.a) + 'exp('+ string(fitresult1.b) + 'x)';
    text(35,9000,txt1);

X_sub2 = X(X>=65);
Y_sub2 = Y(length(X_sub1)+1:length(Y));

 %% Fit: 'linear fit'.
    [xData2, yData2] = prepareCurveData( X_sub2, Y_sub2 );
    
    % Set up fittype and options.
    ft = fittype( 'poly1' );
    
    % Fit model to data.
    [fitresult2, gof] = fit( xData2, yData2, ft );
    
    % Plot fit with data.
    figure( 'Name', 'linear fit' );
    h = plot( fitresult2, xData2, yData2 );
    legend( h, 'Y vs X', 'linear fit', 'Location', 'NorthWest', 'Interpreter', 'none' );
    % Label axes
    xlabel( 'Day since first case', 'Interpreter', 'none' );
    ylabel( 'Net confirmed', 'Interpreter', 'none' );
    grid on;
    txt2 = string(fitresult2.p1) + '*x+ '+ string(fitresult2.p2);
    text(65.5,37500,txt2);
    
     %% Fit: 'polynomial fit'.
    [xData3, yData3] = prepareCurveData( X_sub2, Y_sub2 );
    
    % Set up fittype and options.
    ft = fittype( 'poly2' );
    
    % Fit model to data.
    [fitresult3, gof] = fit( xData3, yData3, ft );
    
    % Plot fit with data.
    figure( 'Name', 'polynomial fit' );
    h = plot( fitresult3, xData3, yData3 );
    legend( h, 'Y vs X', 'polynomial fit', 'Location', 'NorthWest', 'Interpreter', 'none' );
    % Label axes
    xlabel( 'Day since first case', 'Interpreter', 'none' );
    ylabel( 'Net confirmed', 'Interpreter', 'none' );
    grid on;
    txt3 = string(fitresult3.p1) + '*x^2+ '+ string(fitresult3.p2)+'*x+ '+string(fitresult3.p3);
    text(65.5,37500,txt3);

% to compare the quadratic fit with predicted exponential growth of the curve
expected_ex = fitresult.a *exp(fitresult.b *71);
linear_ex = fitresult2.p1*71 + fitresult2.p2;
diff = floor(expected_ex - linear_ex);
fprintf("If the expected exponential growth had happened the expected confirmed count " + ...
    "would be %d but with the linear fit count on last day was %d. This makes a difference of" + ...
    "%d.",expected_ex,linear_ex,diff);

%Obervation
fprintf("As it can be seen from the sub-graphs, the nature of the curve has gone from exponential " + ...
    "in the initial 65 days to a quadratic curve in the later days. This indicates the flattening " + ...
    "nature of the curve as expected. With time the linear nature will turn into a constant" + ...
    "nature where the confirmed cases don't increase with time, indicating the eradication" + ...
    "of active cases");

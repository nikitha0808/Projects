clear; close all; clc;
%This is the main function of MLP
%some parameters
inp_layer = 784;
hidden_layer = 200;
out_layer = 10;

%load training data
load('mnist_data.mat');
m = size(trainImages,1);
n = size(trainImages,2);

% Randomly select 100 data points to display
sel = randperm(m);
sel = sel(1:100);

displayData(trainImages(sel, :));
trainImages = double(trainImages);
testImages = double(testImages);
%initialise random weights to the layers

theta1 = -1+ 2*(rand(hidden_layer, n+1));
theta2 = -1+ 2*(rand(out_layer, hidden_layer+1));

params = [theta1(:); theta2(:)];
train_accuracy = zeros(100,1); %Recording the accuracies
test_accuracy = zeros(100,1);
%training MLP
for i = 1:100
    options = optimset('MaxIter', i);


    lambda = 0.002; %Have to try other values

    % Create "short hand" for the cost function to be minimized
    costFunction = @(p) costfunction(p, ...
        inp_layer, ...
        hidden_layer, ...
        out_layer,trainImages/255, trainLabels, lambda);

    [nn_params, cost] = fmincg(costFunction, params, options);

    %reshape parameters

    Theta1 = reshape(nn_params(1:hidden_layer * (inp_layer + 1)), ...
        hidden_layer, (inp_layer + 1));

    Theta2 = reshape(nn_params((1 + (hidden_layer * (inp_layer + 1))):end), ...
        out_layer, (hidden_layer + 1));


    %predicting test dataset
    pred = predict(Theta1, Theta2, testImages/255);
    train_pred = predict(Theta1, Theta2, trainImages/255);
    test_accuracy(i,1) = mean(double(pred == testLabels')) * 100;
    train_accuracy(i,1) = mean(double(train_pred == trainLabels'))*100;
end


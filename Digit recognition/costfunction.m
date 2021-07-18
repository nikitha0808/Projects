function [J grad] = CostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% return variables
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

X = [ones(m,1),X];

delta_sum1 = zeros(hidden_layer_size,input_layer_size+1);
delta_sum2 = zeros(num_labels,hidden_layer_size+1);

for i = 1:m
  hidden_layer_a = sigmoid(Theta1 * (X(i,:)'));
  hidden_layer_a = [1;hidden_layer_a];
  op_layer = sigmoid(Theta2 * hidden_layer_a);
  op(i,:) = [1:num_labels]==y(i);
  error(i,1) = (op(i,:)*log(op_layer))+((ones(1,num_labels)-op(i,:))*log(ones(num_labels,1)-op_layer));
  
  delta3 = op_layer- op(i,:)';
  delta2 = Theta2'*delta3 .*sigmoidGradient([1;Theta1 * X(i,:)']);
  
  delta_sum2 = delta_sum2 + delta3 * hidden_layer_a';
  delta_sum1 = delta_sum1 + delta2(2:hidden_layer_size+1) * X(i,:);
  
end

J =-(sum(error))/m;
 
red_theta1 = Theta1(:,2:input_layer_size+1);
red_theta2 = Theta2(:,2:hidden_layer_size+1);
nn_params_red = [red_theta1(:);red_theta2(:)];
reg = lambda* (nn_params_red'*nn_params_red)/(2*m);
 
J = J +reg;

Theta1_grad = (delta_sum1 + lambda*[zeros(hidden_layer_size,1),red_theta1])/m;
Theta2_grad = (delta_sum2 + lambda*[zeros(num_labels,1),red_theta2])/m;

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end

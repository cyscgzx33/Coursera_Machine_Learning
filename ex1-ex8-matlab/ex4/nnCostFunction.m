function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);

% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%


%% Part 1: forward propagation
% Part 1-1: cost function
for i = 1 : m
    x = [1, X(i, :)]; % be careful the bias term
    z_2 =  x * Theta1'; 
    a_2 = [1, sigmoid(z_2)]; % be careful the bias term
    z_3 = a_2 * Theta2'; 
    a_3 = sigmoid(z_3);
    h = a_3;
    % necessary modificaton on y from an int to a vector
    y_vec = zeros(10, 1);
    y_vec(y(i)) = 1;
    for k = 1 : num_labels
        J = J + ( -y_vec(k) * log(h(k)) - (1 - y_vec(k)) * log(1 - h(k)) );
    end
end

J = J / m;

% Part 1-2: regularization
J_regularization = 0;
[r_theta1, c_theta1] = size(Theta1);
[r_theta2, c_theta2] = size(Theta2);

%{
Note:
   1) in x, the first one is bias term
   2) in Theta, 1st row is bias term (after transpose, it's 1st col)
   3) "reshape" method takes element columnwise

Representation of matrices format:
->  x * Theta1'
[x     1 x 401    ] [xxxxxxxxxx]
                    [          ]
                    [          ]
                    [ 401 x 25 ]
                    [          ]
                    [          ]
                    [          ]
                    [          ]
%}
for i = 1 : r_theta1
    for j = 2 : c_theta1
        J_regularization = J_regularization + Theta1(i, j)^2;
    end
end

for i = 1 : r_theta2
    for j = 2 : c_theta2
        J_regularization = J_regularization + Theta2(i, j)^2;
    end
end

J = J + J_regularization * lambda / (2*m);

%% Part 2: backpropagation
for i = 1 : m
    x = [1, X(i, :)]; % be careful the bias term
    z_2 =  x * Theta1'; 
    a_2 = [1, sigmoid(z_2)]; % be careful the bias term
    z_3 = a_2 * Theta2'; 
    a_3 = sigmoid(z_3);
    % necessary modificaton on y from an int to a vector
    sz = length(a_3);
    y_vec = zeros(sz, 1);
    y_vec(y(i)) = 1;

    delta_3 = a_3' - y_vec;
    delta_2 = (Theta2' * delta_3) .* sigmoidGradient([1, z_2]');

    Theta1_grad = Theta1_grad + delta_2(2:end) * x;
    Theta2_grad = Theta2_grad + delta_3 * a_2;
end

% divide by the accumulated gradients
Theta1_grad = Theta1_grad / m;
Theta2_grad = Theta2_grad / m;

%% Part 3:
Theta1_grad(:, 2:end) = Theta1_grad(:, 2:end) + lambda / m * Theta1(:, 2:end);
Theta2_grad(:, 2:end) = Theta2_grad(:, 2:end) + lambda / m * Theta2(:, 2:end);

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end

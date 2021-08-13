function [J, grad] = linearRegCostFunction(X, y, theta, lambda)
%LINEARREGCOSTFUNCTION Compute cost and gradient for regularized linear 
%regression with multiple variables
%   [J, grad] = LINEARREGCOSTFUNCTION(X, y, theta, lambda) computes the 
%   cost of using theta as the parameter for linear regression to fit the 
%   data points in X and y. Returns the cost in J and the gradient in grad

% Initialize some useful values
m = length(y); % number of training examples

% You need to return the following variables correctly 
J = 0;
grad = zeros(size(theta));

% ====================== YOUR CODE HERE ======================
% Instructions: Compute the cost and gradient of regularized linear 
%               regression for a particular choice of theta.
%
%               You should set J to the cost and grad to the gradient.
%

%% Part 1.2
for i = 1 : m
    h_x = theta' * X(i, :)';
    J = J + (h_x - y(i)) ^ 2 / (2 * m);
end

J = J + lambda * (theta(2:end)' * theta(2:end)) / (2 * m);

%% Part 1.3 (should work on any [n x 1] theta, but not only [2 x 1])
n = length(grad);
for i = 1 : m
    h_x = theta' * X(i, :)';
    grad(1) = grad(1) + (h_x - y(i)) * X(i, 1);
    for j = 2 : n
        grad(j) = grad(j) + (h_x - y(i)) * X(i, j);
    end
end

grad(1) = grad(1) / m;

for j = 2 : n
    grad(j) = grad(j) / m;
    grad(j) = grad(j) + lambda / m * theta(j);
end

% =========================================================================

grad = grad(:);

end

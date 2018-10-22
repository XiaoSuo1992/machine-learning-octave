% Clear variables and a screen.
clear; close all; clc;

% Loading training data from file ----------------------------------------------
fprintf('Loading the training data from file...\n');

% Loading training data from file.
data = load('house_prices.csv');

% Split data into features and results.
X = data(:, 1:2);
y = data(:, 3);

% Plotting training data -------------------------------------------------------
fprintf('Plotting the training data...\n');

% Create a window, position and resize it.
figure(1, 'position', [50, 50, 850, 650]);

% Split the figure on 2x2 sectors.
% Start drawing in first sector.
subplot(2, 2, 1);

scatter3(X(:, 1), X(:, 2), y, [], y(:), 'o');
title('Training Set');
xlabel('Size');
ylabel('Rooms');
zlabel('Price');

% Running linear regression ----------------------------------------------------
fprintf('Running linear regression...\n');

alpha = 0.1;
num_iterations = 50;
[theta mu sigma X_normalized J_history] = linear_regression(X, y, alpha, num_iterations);

fprintf('- Initial cost: %f\n', J_history(1));
fprintf('- Optimized cost: %f\n', J_history(end));

% Calculate model parameters using normal equation -----------------------------
fprintf('Calculate model parameters using normal equation...\n');

[theta_normal] = normal_equation(X, y);
normal_cost = J(X, y, theta_normal);

fprintf('- Normal function cost: %f\n', normal_cost);

% Plotting normalized training data --------------------------------------------
fprintf('Plotting normalized training data...\n');

% Start drawing in second sector.
subplot(2, 2, 2);

scatter3(X_normalized(:, 2), X_normalized(:, 3), y, [], y(:), 'o');
title('Normalized Training Set');
xlabel('Normalized Size');
ylabel('Normalized Rooms');
zlabel('Price');

% Draw gradient descent progress ------------------------------------------------
fprintf('Plot gradient descent progress...\n');

% Continue plotting to the right area.
subplot(2, 2, 3);

plot(1:num_iterations, J_history);
xlabel('Iteration');
ylabel('J(\theta)');
title('Gradient Descent Progress');

% Plotting hypothesis plane on top of training set -----------------------------
fprintf('Plotting hypothesis plane on top of training set...\n');

% Get apartment size and rooms boundaries.
apt_sizes = X_normalized(:, 2);
apt_rooms = X_normalized(:, 3);
apt_size_range = linspace(min(apt_sizes), max(apt_sizes), 10);
apt_rooms_range = linspace(min(apt_rooms), max(apt_rooms), 10);

% Calculate predictions for each possible combination of rooms number and appartment size.
apt_prices = zeros(length(apt_size_range), length(apt_rooms_range));
for apt_size_index = 1:length(apt_size_range)
    for apt_room_index = 1:length(apt_rooms_range)
        X = [1, apt_size_range(apt_size_index), apt_rooms_range(apt_room_index)];
        apt_prices(apt_size_index, apt_room_index) = h(X, theta);
    end
end

% Plot the plane on top of training data to see how it feets them.
subplot(2, 2, 2);
hold on;
mesh(apt_size_range, apt_rooms_range, apt_prices);
hold off;

% Feature normalization fonksiyonu
function [x_norm, mu, sigma] = featureNormalize(x)
    x_norm = x;
    mu = zeros(1, size(x, 2));
    sigma = zeros(1, size(x, 2));

    for i=1:size(x, 2)
        mu(i) = mean(x(:, i));
        sigma(i) = std(x(:, i));
        x_norm(:, i) = (x(:, i) - mu(i)) / sigma(i);
    end
end

% Gradient descent fonksiyonu
function [theta, J_history] = gradientDescent(x, y, theta, alpha, num_iters)
    m = length(y);
    J_history = zeros(num_iters, 1);

    for iter = 1:num_iters
        predictions = x * theta;
        errors = predictions - y;
        theta = theta - (alpha/m) * (x' * errors);
        J_history(iter) = computeCostMulti(x, y, theta);
    end
end

% Maliyet fonksiyonu
function j = computeCostMulti(x, y, theta)
    m = length(y);
    predictions = x * theta;
    j = 1/(2*m) * sum((predictions - y).^2);
end

% Normal equation fonksiyonu
function [theta] = normalEqn(x, y)
    theta = pinv(x' * x) * x' * y;
end

function mape = MAPE(y_true, y_pred)
    mape = mean(abs((y_true - y_pred) ./ y_true)) * 100;
end


araba = readtable('7_Carprice_Assignment.csv');
x = [araba.carlength, araba.carwidth, araba.carheight];
y = araba.price;

[X_norm, mu, sigma] = featureNormalize(x);

X = [ones(size(X_norm, 1), 1), X_norm];

%gradyan iniş paramterleri
alpha = 0.01;
num_iters = 400;
theta = zeros(4, 1);

[theta_grad, J_history] = gradientDescent(X, y, theta, alpha, num_iters);

theta_normal = normalEqn(X, y);

test_araba = [(170 - mu(1))/sigma(1), (65 - mu(2))/sigma(2), (54 - mu(3))/sigma(3)];
test_araba = [1, test_araba];

fiyat_grad = test_araba * theta_grad;
fiyat_normal = test_araba * theta_normal;

fprintf('Gradient descent yöntemi ile tahmin edilen fiyat: %.2f TL\n', fiyat_grad);
fprintf('NFeature normalization yöntemi ile tahmin edilen fiyat: %.2f TL\n', fiyat_normal);

gercek_fiyatlar = y;

tahmin_grad = X * theta_grad;
tahmin_normal = X * theta_normal;

mape_grad = MAPE(gercek_fiyatlar, tahmin_grad);
mape_normal = MAPE(gercek_fiyatlar, tahmin_normal);

fprintf('Gradyan iniş yöntemi ile MAPE: %.2f%%\n', mape_grad);
fprintf('Normal denklem yöntemi ile MAPE: %.2f%%\n', mape_normal);
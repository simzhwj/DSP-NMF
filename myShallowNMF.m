function [U, V, dnorms] = myShallowNMF(X, r, maxiter, tolfun, sd)

rand('twister',sd);

[m, n] = size(X);
U = rand(m, r);
V = rand(r, n);

U = NormalizeFea(U, 0);
V = NormalizeFea(V, 0);

dnorm0 = norm(X - U * V, 'fro') + norm(V - U' * X, 'fro');%Frobenius 范数

for i = 1:maxiter
    % update U
    
    U = U .* (2 * X * V') ./ max(U * (V * V') + X * (X' * U), 1e-10);
    % update V
    
    V = V .* (2 * U' * X) ./ max(U' * U * V + V, 1e-10);
    dnorm = norm(X - U * V, 'fro') + norm(V - U' * X, 'fro');
    
    if abs(dnorm0 - dnorm) <= tolfun
        break; % converge
    end
    
    dnorm0 = dnorm;
    dnorms(i) = dnorm;
end
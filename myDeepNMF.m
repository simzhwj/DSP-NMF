function [Ui, Vi, Vs, err,alpha] = myDeepNMF(X, U, V, layers, lambda, alpha,gamma, Vs)
nV = size(X,3); 
p = numel(layers);

for v = 1:nV
    
    Xv = X(:,:,v);
    A = Xv; 
    D = diag(sum(A));
    L = D - A;
    Q = cell(p + 1,v);
    AAT = A * A';
    
    Q{p + 1,v} = eye(layers(p));
    for i_layer = p:-1:2
        Q{i_layer,v} = U{i_layer,v} * Q{i_layer + 1,v};
    end
    
    VpVpT = V{p,v} * V{p,v}';
    
    %% Update layer by layer
    for i = 1:p
        % Update Ui
        if i == 1
            R = U{1,v} * (Q{2,v} * VpVpT *  Q{2,v}') + AAT * (U{1,v} * (Q{2,v} * Q{2,v}'));
            Ru = 2 * A * (V{p,v}' * Q{2,v}');
            U{1,v} = U{1,v}.* Ru ./ max(R, 1e-10);
        else
            R = P' * P * U{i,v} * Q{i + 1,v} * VpVpT * Q{i + 1,v}' + P' * AAT * P * U{i,v} * Q{i + 1,v} * Q{i + 1,v}';
            Ru = 2 * P' * A * V{p,v}' * Q{i + 1,v}';
            U{i,v} = U{i,v}.* Ru ./ max(R, 1e-10);
        end
        
        % Update Vi
        if i == 1
            P = U{i,v};
        else
            P = P * U{i,v};
        end
        if i < p
            Vu = 2 * P' * A;
            Vd = P' * P * V{i,v} + V{i,v};
            V{i,v} = V{i,v} .* Vu ./ max(Vd, 1e-10);
        else

            Vu = 2 * P' * A + lambda * V{i,v} * A + alpha(v)^gamma * Vs;
            Vd = P' * P * V{i,v} + V{i,v} + lambda * V{i,v} * D + alpha(v)^gamma * V{i,v};
            V{i,v} = V{i,v} .* Vu ./ max(Vd, 1e-10);
        end
    end
    
    dnorm(v) = cost_function(A, P, V{p,v}, L, lambda, alpha(v), gamma,Vs);
    
end

alpha=alpha_update(alpha,gamma,p,nV,V,Vs);
Vs =Vs_update(alpha,gamma,p,V,nV);
err = dnorm;
Ui = U;
Vi = V;

end


function error = cost_function(A, Up, Vp, L, lambda, alpha,gamma, Vs)
    error = norm(A - Up * Vp, 'fro')^2 + norm(Vp - Up' * A, 'fro')^2 + lambda * trace(Vp * L * Vp') + alpha^gamma * norm(Vp - Vs, 'fro')^2;
    error = sqrt(error);
end
   

function alpha = alpha_update(alpha,gamma,p,nV,V,Vs)
    alpha_d=0;
    for i_v =1:nV
        alpha_d=alpha_d+norm(V{p,i_v}-Vs, 'fro')^(2/(1-gamma));
    end
    for i_v=1:nV
            alpha(i_v)=norm(V{p,i_v}-Vs, 'fro')^(2/(1-gamma))/alpha_d;
    end
end

function Vs = Vs_update(alpha,gamma,p,V,nV)
    u=zeros(size(V{p,1}));
    d=0;
    for i_v=1:nV
        u=u+alpha(i_v)^gamma*V{p,i_v};
        d=d+alpha(i_v)^gamma;
    end
    Vs=u/d;
end
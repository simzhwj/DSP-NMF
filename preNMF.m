function [U, V, E] = preNMF(X, Param)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%------------Pre-training---------------%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
maxIter = Param.maxIter;
layers = Param.layers;
tolfun = Param.tolfun;
sd = Param.sd;

p = length(layers);
for v = 1:size(X,3)
    for i_layer = 1:p
        if i_layer == 1
            Z = X(:,:,v);
        else
            Z = V{i_layer - 1,v};
        end

        [U{i_layer,v}, V{i_layer,v}, E{i_layer,v}] = ...
            myShallowNMF(Z, layers(i_layer), maxIter, tolfun, sd);
    end
end




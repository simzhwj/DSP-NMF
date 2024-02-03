function [U, V, E, Vs] = fineNMF(X, Param)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%------------Fine-tuning----------------%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
maxIter = Param.maxIter;
layers = Param.layers;
tolfun = Param.tolfun;
lambda = Param.lambda;
alpha = Param.alpha;
gamma=Param.gamma;

Vind = Param.Vind;
U0 = Param.U;
V0 = Param.V;
Vs = V0{end,Vind};
true_label=Param.true_label;
E=[];
for i = 1:maxIter
    
    [Ui, Vi, Vs, err,alpha] = myDeepNMF(X, U0, V0, layers, lambda, alpha,gamma, Vs);
    
    U{i} = Ui;
    V{i} = Vi;
    E=[E;err] ;
    if err < tolfun
        break;
    end
    Vp=Vs';
    [~,Predic_nmf]=max(Vp,[],2); 
    [Predic_nmf]=BestMapping(true_label,Predic_nmf);
    
end
end





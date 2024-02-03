# DSP-NMF

This work is Under Reviewed by the joural of Applied Intelligence

Please download the related datasets and make the main file according to the following statements


load('ndata/football.mat');

%% pre-training param.
pParam.maxIter = 500;
pParam.tolfun = 5e-6;
pParam.sd = 5489;
% pParam.layers = layerFilter(layers, size(A,1), length(unique(true_lable)));
pParam.layers = [210,178,150,128,64,32,20];
pParam.sd=5489;

%% fine-tuning param.
fParam.maxIter = 10;
fParam.tolfun = 5e-6;
fParam.layers = pParam.layers;

fParam.alpha = [0,1,0];
fParam.gamma = 2.17;
fParam.lambda = 0.1;
fParam.Vind = 2;
fParam.true_label = true_label;

[U0, V0, E0] = preNMF(X, pParam);
fParam.U = U0;
fParam.V = V0;
[Ud, Vd, Ed, Vs] = fineNMF(X, fParam);
Ed=Ed';


%% testing
Vp=Vs';
[~,Predic_nmf]=max(Vp,[],2); 
[Predic_nmf]=BestMapping(true_label,Predic_nmf);


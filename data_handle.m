%%处理community数据时要把成员数最多的一行放到第一行
clear;clc
ids=load('./politicsukviews/politicsuk.ids');
xlswrite('politicsuk_v.xlsx',ids,8,'A1');
class=importdata('./politicsukviews/politicsuk.communities');
nclass=size(class,1);

true_lable=ids;
n=size(true_lable,1);   %数据的个体数量
for i=1:nclass
    for j=1:n
        if ismember(true_lable(j),class(i,:))
            true_lable(j)= i;
        end
    end
end

maindir='politicsukviews';%数据集目录
subdir=dir(fullfile(maindir,'*.mtx'));
views=length(subdir);
A=zeros(n,n,views);

for i=1:views
    E_list =load(['./politicsukviews/',subdir(i).name]);    % 读取网络数据集（边集）
    xlswrite('politicsuk_v.xlsx',E_list,i+4,'A1');
    m = size(E_list,1);     % m为网络边总数
    for k=1:2
        for i_n=1:n
            for j=1:m
                if ismember(E_list(j,k),ids(i_n,:))
                    E_list(j,k)= i_n;
                end
            end
        end
    end
    Adj = sparse(E_list(:, 1),E_list(:, 2),ones(m, 1), n, n);   % 网络边集转为邻接矩阵
    Adj = full(Adj);    % 稀疏格式邻接矩阵转为全格式邻接矩阵
    Adj=Adj'|Adj;
    display( issymmetric(Adj));
    A(:,:,i) = Adj;     % A为邻接矩阵（Adjacency）% ！！！当边集是无向时，执行此操作，否则注释掉！！！
    
    %A=(A'+A)./2;
end

% save('rugby.mat','true_lable','views','A')
% 


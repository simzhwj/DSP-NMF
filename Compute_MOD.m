function  [Q1]=Compute_MOD(A,a)
% A是图的邻接矩阵， a是n*1的向量,即每个节点所属社区。
one = 1: length (A);
a = [one' a];
% 　建立节点社区矩阵
a =  accumarray (a,1);
a = a(:, any (a)); %　 删除A中全0的列
% 　进行网络A模块度Ｑ1运算
m =  sum ( sum (A))/2;
k =  sum (A,2);
B = A - (repmat(k,[1,size(A,1)]) .* repmat(k',[size(A,1),1])) / (2*m);
Q1 = 1/(2*m) .*  trace (a'*B*a);
end
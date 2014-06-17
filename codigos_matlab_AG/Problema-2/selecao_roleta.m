function S=selecao_roleta(P,Fn);
% selecao de individuos pelo metodo da roleta em funcao de suas aptidoes
% normalizadas

n=size(P);

[Fn_sort I]=sort(Fn,2,'descend');  % ordena os valores das aptidoes em ordem crescente 

Fn_acc = cumsum(Fn_sort);

S=[];
for i=1:n/2,
   I1=roda_roleta(Fn_acc,I);  % Indice do individuo selecionado 1
   I2=roda_roleta(Fn_acc,I);  % Indice do individuo selecionado 2
   S=[S; I1 I2];
end


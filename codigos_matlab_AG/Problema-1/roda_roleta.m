function Is=roda_roleta(Fn_acc,I);
% selecao de individuos pelo metodo da roleta em funcao de suas aptidoes
% normalizadas

u=rand;  % gera numero aleatorio entre 0 e 1

J=find(Fn_acc>=u);  % Indices de todos os valores de Fn_acc >= u.

Is=I(J(1));
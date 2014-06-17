function [X,F,Fn]=aptidao2(P);
% Calcula aptidao dos individuos da populacao P
% Entrada:
%    P - Matriz binaria representando os individuos de uma geracao
%    nas linhas e os genes nas colunas
% Saida:
%    X - Fenotipo,  i.e. valores correspondentes em base decimal aos 
%        numeros binarios codificados nos individuos da populacao P 
%    F - Valores correspondentes da funcao de aptidao para os individuos 
%        da populacao P
%    Fn - Valores normalizados das aptidoes dos individuos da populacao 

n=size(P);


Xmin=-1; Xmax=2;
aux=1/(2^22 - 1);
for i=1:n(1),
    
    %% MATLAB
    %X(i)=bi2de(P(i,:),'left-msb'),  % Converte palavra binaria para string
    
    %% OCTAVE
    X(i)=bina2deci(P(i,:)),
    pause
    X(i)=Xmin+(Xmax-Xmin)*X(i)*aux
    F(i)=X(i)*sin(10*pi*X(i))+1
end
Fn=F/sum(F);  % Aptidoes normalizadas

X=X';
F=F';
Fn=Fn';

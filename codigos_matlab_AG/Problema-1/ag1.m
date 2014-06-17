% Implementacao de um AG binario canonico para encontrar o maximo da
% funcao f(x)=x^2, 0<=x<=31.
%
% Autor: Guilherme A. Barreto
% Data: 17/08/2009

clear; clc;

%%% Parametros do AG
N=4;     % Tamanho da populacao
M=5;    % Tamanho do cromossomo (no. de genes)
pc=0.8;  % Probabilidade de cruzamento
pm=0.01; % Probabilidade de mutacao
Ng=20;   % Numero de geracoes

%%% Geracao da populacao inicial 
P=round(rand(N,M));

%%% Calcula fitness da populacao inicial
[X F Fn]=aptidao(P);  % Retorna a aptida de cada individuo da populcao

%%% Roda AG por Ng geracoes
for t=1:Ng,
    geracao=t,
    S=selecao_torneio(P,Fn);
    P=cruzamento(P,S,pc);
    P=mutacao(P,pm)
    [X F Fn]=aptidao(P);
    F,X
    pause
end

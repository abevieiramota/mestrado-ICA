% Implementacao de um sistema de inferencia fuzzy
% ENTRADAS: x1 (velocidade, Km/h), x2 (raio de curvatura, m)
% SAIDA:  y (forca no pedal de freio, N)
%
% Autor: Guilherme A. Barreto 
% Data:  03/10/2009

clear; clc; close all;

% Valores medidos de x1 e x2
x1=100;
x2=50;

%%%%%%%%%%%%
% ETAPA 1: FUZZIFICACAO
%%%%%%%%%%%%

mi1=velocidade(x1);   % Pertinencias para variavel VELOCIDADE
mi2=curvatura(x2);     % Pertinencias para variavel CURVATURA

% VARIAVEL DE SAIDA (Funcoes de Pertinencia)
y=0:0.1:10;   % Universo de discurso da variavel de saida
mi_out=[];
for i=1:length(y),
	aux=forca_pedal_freio(y(i));
	mi_out=[mi_out; aux];
end

%%%%%%%%%%%%
% ETAPA 2: AVALIACAO DAS REGRAS FUZZY
%%%%%%%%%%%%

RULE_OUT=regras(mi1,mi2,mi_out,y);  % Conjuntos fuzzy de saida de todas as regras

%%%%%%%%%%%%
% ETAPA 3: INFERENCIA FUZZY (AGREGACAO - OR)
%%%%%%%%%%%%

F_OUT=sum(RULE_OUT);

figure;
plot(y,F_OUT);
xlabel('Forca no pedal de freio');
title('Conjunto Fuzzy de Saida Agregado');
axis([0 10 0 1.2])

%%%%%%%%%%%%
% ETAPA 4: DESFUZZIFICACAO (CENTRO DE GRAVIDADE)
%%%%%%%%%%%%

Y=sum(F_OUT.*y)/sum(F_OUT);

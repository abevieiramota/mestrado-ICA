% Implementacao da rede Perceptron (Simples) Logistico
% Funcao de ativacao tangente hiperbolica
% Usando as funcoes built-in (internas) do matlab
%
% Exemplo para disciplina de ICA
% Autor: Guilherme de A. Barreto
% Date: 26/12/2008


% X = Vetor de entrada
% d = saida desejada (escalar)
% W = Matriz de pesos Entrada -> Camada Oculta
% M = Matriz de Pesos Camada Oculta -> Camada saida
% eta = taxa de aprendizagem
% alfa = fator de momento

clear; clc;

% Carrega DADOS
%=================
load derm_input.txt;
load derm_target.txt;
%load wine_input.txt
%load wine_target.txt
%load column_input.txt
%load column_target.txt

dados=derm_input;  % Vetores (padroes) de entrada
alvos=derm_target; % Saidas desejadas correspondentes
%dados=wine_input;
%alvos=wine_target;
%dados=column_input;
%alvos=column_target;

clear derm_input;  % Libera espaco em memoria
clear derm_target;
%clear wine_input;  
%clear wine_target;
%clear column_input; 
%clear column_target;

% Embaralha vetores de entrada e saidas desejadas
[LinD ColD]=size(dados);

% Normaliza componentes para media zero e variancia unitaria
for i=1:LinD,
	mi=mean(dados(i,:));  % Media das linhas
    di=std(dados(i,:));   % desvio-padrao das linhas 
	dados(i,:)= (dados(i,:) - mi)./di;
end 
Dn=dados;

% Define tamanho dos conjuntos de treinamento/teste (hold out)
ptrn=0.8;    % Porcentagem usada para treino

% DEFINE ARQUITETURA DA REDE
%=========================
Ne = 50; % No. de epocas de treinamento
Nr = 10;   % No. de rodadas de treinamento/teste
No = 6;   % No. de neuronios na camada de saida

eta=0.1;   % Passo de aprendizagem

%% Inicio do Treino
for r=1:Nr,  % LOOP DE RODADAS TREINO/TESTE

    Rodada=r,

    I=randperm(ColD);
    Dn=Dn(:,I);
    alvos=alvos(:,I);   % Embaralha saidas desejadas tambem p/ manter correspondencia com vetor de entrada

    J=floor(ptrn*ColD);

    % Vetores para treinamento e saidas desejadas correspondentes
    P = Dn(:,1:J); T1 = alvos(:,1:J);
    [lP cP]=size(P);   % Tamanho da matriz de vetores de treinamento

    % Vetores para teste e saidas desejadas correspondentes
    Q = Dn(:,J+1:end); T2 = alvos(:,J+1:end);
    [lQ cQ]=size(Q);   % Tamanho da matriz de vetores de teste

    % Inicia matrizes de pesos
    WW=0.1*rand(No,lP+1);   % Pesos entrada -> camada saida

    %%% ETAPA DE TREINAMENTO
    for t=1:Ne,
        Epoca=t;
        I=randperm(cP); P=P(:,I); T1=T1(:,I);   % Embaralha vetores de treinamento
        EQ=0;
        for tt=1:cP,   % Inicia LOOP de epocas de treinamento
            % CAMADA DE SAIDA
            X  = [-1; P(:,tt)];   % Constroi vetor de entrada com adicao da entrada x0=-1
            Ui = WW * X;          % Ativacao (net) dos neuronios de saida
            Yi = (Ui > 0);        % Saida quantizada em (0 ou 1)

            % CALCULO DO ERRO
            Ei = T1(:,tt) - Yi;           % erro entre a saida desejada e a saida da rede
            EQ = EQ + 0.5*sum(Ei.^2);     % soma do erro quadratico de todos os neuronios p/ VETOR DE ENTRADA

            WW = WW + eta*Ei*X';  % AJUSTE DOS PESOS - CAMADA DE SAIDA

        end   % Fim de uma epoca

        EQM(t)=EQ/cP;  % MEDIA DO ERRO QUADRATICO POR EPOCA
    end   % Fim do loop de treinamento


    %% ETAPA DE GENERALIZACAO  %%%
    EQ2=0; HID2=[]; OUT2=[];
    for tt=1:cQ,
        % CAMADA OCULTA
        X=[-1; Q(:,tt)];      % Constroi vetor de entrada com adicao da entrada x0=-1
        Ui = WW * X;          % Ativacao (net) dos neuronios da camada oculta
        Yi = (Ui>0);          % Saida quantizada em (0 ou 1)
        OUT2=[OUT2 Yi];       % Armazena saida da rede

        % CALCULO DO ERRO DE GENERALIZACAO
        Ei = T2(:,tt) - Yi;
        EQ2 = EQ2 + 0.5*sum(Ei.^2);
    end

    % ERRO QUADRATICO MEDIO P/ DADOS DE TESTE
    EQM2=EQ2/cQ;

    % CALCULA TAXA DE ACERTO
    count_OK=0;  % Zera contador de acertos
    for t=1:cQ,
        [T2max iT2max]=max(T2(:,t));  % Indice da saida desejada de maior valor
        [OUT2_max iOUT2_max]=max(OUT2(:,t)); % Indice do neuronio cuja saida eh a maior
        if iT2max==iOUT2_max,   % Conta acerto se os dois indices coincidem
            count_OK=count_OK+1;
        end
    end

    % Taxa de acerto global
    Tx_OK(r)=100*(count_OK/cQ);

end % FIM DO LOOP DE RODADAS TREINO/TESTE

Tx_media=mean(Tx_OK),  % Taxa media de acerto global
Tx_std=std(Tx_OK), % Desvio padrao da taxa media de acerto 

% Plota Curva de Aprendizagem
%plot(EQM)


% Implementacao da rede MLP canonica 
% Backpropagation com gradiente descendente + termo de momento
% Funcao de ativacao sigmoide logistica
% Usando as funcoes built-in (internas) do matlab
%
% Exemplo para disciplina de ICA
% Autor: Guilherme de A. Barreto
% Date: 14/05/2014


% X = Vetor de entrada
% d = saida desejada (escalar)
% W = Matriz de pesos Entrada -> Camada Oculta
% M = Matriz de Pesos Camada Oculta -> Camada saida
% eta = taxa de aprendizagem
% alfa = fator de momento

clear; clc; close all;

% Carrega DADOS
%=================
% load xor_input.txt
% load xor_target.txt
% dados=xor_input;
% alvos=xor_target;
% clear xor_input xor_target;

% load twomoons_input.txt
% load twomoons_target.txt
% dados=twomoons_input;
% alvos=twomoons_target;
% clear twomoons_input twomoons_target;

% load circular_input.txt
% load circular_target.txt
% dados=circular_input';
% alvos=circular_target';
% clear circular_input circular_target;

load oito_input.txt
load oito_target.txt
dados=oito_input';
alvos=oito_target';
clear oito_input oito_target;


% Embaralha vetores de entrada e saidas desejadas
[LinD ColD]=size(dados);

Dn=dados;

% LIMITES DOS EIXOS X e Y (superficie de decisao)
Xmin=min(Dn(1,:)); Xmax=max(Dn(1,:));
Ymin=min(Dn(2,:)); Ymax=max(Dn(2,:));

% Define tamanho dos conjuntos de treinamento/teste (hold out)
ptrn=0.8;    % Porcentagem usada para treino

% DEFINE ARQUITETURA DA REDE
%===========================
Ne = 100; % No. de epocas de treinamento
Nr = 1;   % No. de rodadas de treinamento/teste
Nh = 30;   % No. de neuronios na camada oculta
No = 1;   % No. de neuronios na camada de saida

eta=0.10;   % Passo de aprendizagem
mom=0.10;  % Fator de momento

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
    WW=0.1*rand(Nh,lP+1);   % Pesos entrada -> camada oculta
    WW_old=WW;              % Necessario para termo de momento

    MM=0.1*rand(No,Nh+1);   % Pesos camada oculta -> camada de saida
    MM_old = MM;            % Necessario para termo de momento

    %%% ETAPA DE TREINAMENTO
    for t=1:Ne,   % Inicia LOOP de epocas de treinamento
        Epoca=t;
        
        I=randperm(cP); P=P(:,I); T1=T1(:,I);   % Embaralha vetores de treinamento
        
        EQ=0;
        HID1=[];
        for tt=1:cP,   % Inicia LOOP de iteracoes em uma epoca de treinamento
            % CAMADA OCULTA
            X  = [-1; P(:,tt)];   % Constroi vetor de entrada com adicao da entrada x0=-1
            Ui = WW * X;          % Ativacao (net) dos neuronios da camada oculta
            Zi = 1./(1+exp(-Ui)); % Saida entre [0,1] (funcao logistica)
            HID1=[HID1 Zi];

            % CAMADA DE SAIDA
            Z  = [-1; Zi];        % Constroi vetor de entrada DESTA CAMADA com adicao da entrada y0=-1
            Uk = MM * Z;          % Ativacao (net) dos neuronios da camada de saida
            Yk = 1./(1+exp(-Uk)); % Saida entre [0,1] (funcao logistica)

            % CALCULO DO ERRO
            Ek = T1(:,tt) - Yk;           % erro entre a saida desejada e a saida da rede
            EQ = EQ + 0.5*sum(Ek.^2);     % soma do erro quadratico de todos os neuronios p/ VETOR DE ENTRADA

            %%% CALCULO DOS GRADIENTES LOCAIS
            Dk = Yk.*(1 - Yk)+0.01;  % derivada da sigmoide logistica (camada de saida)
            DDk = Ek.*Dk;       % gradiente local (camada de saida)

            Di = Zi.*(1 - Zi)+0.01; % derivada da sigmoide logistica (camada oculta)
            DDi = Di.*(MM(:,2:end)'*DDk);    % gradiente local (camada oculta)

            % AJUSTE DOS PESOS - CAMADA DE SAIDA
            MM_aux=MM;
            MM = MM + eta*DDk*Z' + mom*(MM - MM_old);
            MM_old=MM_aux;

            % AJUSTE DOS PESOS - CAMADA OCULTA
            WW_aux=WW;
            WW = WW + 2*eta*DDi*X' + mom*(WW - WW_old);
            WW_old=WW_aux;
        end   % Fim de uma epoca
        %HID1, pause;
        
        EQM(t)=EQ/cP;  % MEDIA DO ERRO QUADRATICO POR EPOCA
    end   % Fim do loop de treinamento
    
    figure; plot(EQM);  % Plota Curva de Aprendizagem
    xlabel('epocas de treinamento');  ylabel('EQM');
    title('Erro quadratico medio (EQM) por epoca')

    %% ETAPA DE GENERALIZACAO  %%%
    EQ2=0; HID2=[]; OUT2=[];
    for tt=1:cQ,
        % CAMADA OCULTA
        X=[-1; Q(:,tt)];      % Constroi vetor de entrada com adicao da entrada x0=-1
        Ui = WW * X;          % Ativacao (net) dos neuronios da camada oculta
        Zi = 1./(1+exp(-Ui)); % Saida entre [0,1] (funcao logistica)

        % CAMADA DE SAIDA
        Z=[-1; Zi];           % Constroi vetor de entrada DESTA CAMADA com adicao da entrada y0=-1
        Uk = MM * Z;          % Ativacao (net) dos neuronios da camada de saida
        Yk = 1./(1+exp(-Uk)); % Saida entre [0,1] (funcao logistica)
        OUT2=[OUT2 Yk];       % Armazena saida da rede

        % ERRO QUADRATICO GLOBAL (todos os neuronios) POR VETOR DE ENTRADA
        EQ2 = EQ2 + 0.5*sum(Ek.^2);
    end

    % MEDIA DO ERRO QUADRATICO COM REDE TREINADA (USANDO DADOS DE TESTE)
    EQM2=EQ2/cQ;

    % CALCULA TAXA DE ACERTO
    count_OK=0;  % Contador de acertos
    for t=1:cQ,
        [T2max iT2max]=max(T2(:,t));  % Indice da saida desejada de maior valor
        [OUT2_max iOUT2_max]=max(OUT2(:,t)); % Indice do neuronio cuja saida eh a maior
        if iT2max==iOUT2_max,   % Conta acerto se os dois indices coincidem
            count_OK=count_OK+1;
        end
    end

    % Taxa de acerto global
    Tx_OK(r)=100*(count_OK/cQ)

end % FIM DO LOOP DE RODADAS TREINO/TESTE

Tx_media=mean(Tx_OK),  % Taxa media de acerto global
Tx_std=std(Tx_OK), % Desvio padrao da taxa media de acerto 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plota SUPERFICIE DE DECISAO  %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
incr=0.05;
Lx=Xmin:incr:Xmax;
Ly=Ymin:incr:Ymax;

SD1=[]; SD2=[];
for i=1:length(Lx),
    for j=1:length(Ly),
        T=(i-1)*length(Ly)+j;
        % CAMADA OCULTA
        X=[-1; Lx(i); Ly(j)];      % Constroi vetor de entrada com adicao da entrada x0=-1
        Ui = WW * X;          % Ativacao (net) dos neuronios da camada oculta
        Zi = 1./(1+exp(-Ui)); % Saida entre [0,1] (funcao logistica)
      
        % CAMADA DE SAIDA
        Z=[-1; Zi];           % Constroi vetor de entrada DESTA CAMADA com adicao da entrada y0=-1
        Uk = MM * Z;          % Ativacao (net) dos neuronios da camada de saida
        Yk = 1./(1+exp(-Uk)); % Saida entre [0,1] (funcao logistica)
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%% METODO 1: Colorir regioes de atracao %%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if round(Yk)==1, 
            SD1=[SD1; Lx(i) Ly(j) 1 0 0];
        else SD1=[SD1; Lx(i) Ly(j) 0 1 0];
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% METODO 3: Determina curvas 2D (fronteiras) entre classes %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R=SD1(:,3:end);
SD3=[];
for i=2:length(R),
    [V I1]=max(R(i-1,:));
    [V I2]=max(R(i,:));
    if (I2~=I1) & (mod(i-1,length(Ly))~=0),
        SD3=[SD3; SD1(i,1:2)];
    end
end

figure; 
scatter(SD1(:,1),SD1(:,2),[],SD1(:,3:end),'filled'); hold on
plot(Dn(1,:),Dn(2,:),'ko'); hold off;
axis([Xmin Xmax Ymin Ymax]);

I0=find(alvos==0);  % Encontra indices das saidas desejadas = 0
I1=find(alvos==1);  % Encontra indices das saidas desejadas = 1

figure; 
plot(Dn(1,I0),Dn(2,I0),'ro',Dn(1,I1),Dn(2,I1),'b*'); hold on;
plot(SD3(:,1),SD3(:,2),'k.','MarkerSize',15); hold off;
axis([Xmin Xmax Ymin Ymax]);

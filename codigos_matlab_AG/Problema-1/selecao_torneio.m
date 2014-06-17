function S=selecao_torneio(P,Fn);
% selecao de individuos pelo metodo do sorteio

n=size(P);

S=[];
for i=1:n(1)/2,

    % Seleciona 1o. individuo do par (PAI)
    I=randperm(n(1));  % Numeros inteiros de 1 a n(1) em ordem aleatoria
    I1=I(1); I2=I(2); % Pega dois primeiros indices
    
    if Fn(I1) > Fn(I2), % Seleciona individuo de maior fitness
    	Pai=I1;
    else
	Pai=I2;
    end

    % Seleciona 2o. individuo do par (MAE)
    I=randperm(n(1));  % Numeros inteiros de 1 a n(1) em ordem aleatoria
    I1=I(1); I2=I(2);  % Pega dois primeiros indices
    
    if Fn(I1) > Fn(I2), % Seleciona individuo de maior fitness
    	Mae=I1;
    else
	Mae=I2;
    end

    S=[S;Pai Mae];
end
    

function Pnew=cruzamento(P,S,Pc);
% selecao de individuos pelo metodo do sorteio

n=size(P);

Pnew=[];
for i=1:n(1)/2,
    u=rand;
    if u<=Pc,
	    % Determina ponto de corte aleatoriamente
    	    cut=floor((n(2)-1)*rand) + 1;
    
    	    % Determina filhos
    	    F1=[P(S(i,1),1:cut) P(S(i,2),cut+1:end)];
    	    F2=[P(S(i,2),1:cut) P(S(i,1),cut+1:end)];
    
	    Pnew=[Pnew;F1;F2];
    else
	    % Determina filhos
    	    F1=P(S(i,1),:);
    	    F2=P(S(i,2),:);
    
	    Pnew=[Pnew;F1;F2];
    end
end
    

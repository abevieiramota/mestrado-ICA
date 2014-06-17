function Pnew=mutacao(P,Pm);
% Promove mutacao nos genes dos individuos da populacao P,
% com probabilidade Pm

n=size(P);

Pnew=P;
for i=1:n(1),
    u=rand(n(2),1);
    I=find(u<=Pm);
    for j=1:length(I),
	if Pnew(i,I(j))==0,
		Pnew(i,I(j))=1;
	else Pnew(i,I(j))=0;
	end
    end
end

    

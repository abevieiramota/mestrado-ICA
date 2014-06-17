function Y=bina2deci(X)

n=length(X);

ex=fliplr(cumsum(ones(1,n)))-1;

aux=2.^ex;

%Y=X'*aux;
Y=dot(X,aux);
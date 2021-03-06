%
% function [D,alpha]=Metaface(X,p,lambda,Jstep_T,Max_iteration)
%
%  This fuction initialize the Dictionary using PCA.  
%
% output:D an dictionary we want to learn with size of m by p
% input :X denote the dataset matrix with size of m by n, every column of X denote one image
% Jstep_T:  the reduction of object value in each step
% lamba: denote a coeff of l1_ls
% the formula is that : J=
% argmin(D,alpha){norm(X-D*alpha,2)^2+lamta*norm(alpha,1)}
%
function [D,alpha]=Metaface(X,p,lambda,Jstep_T,Max_iteration)

n           =   size(X,2);
Jnow        =   10;
Jpre        =   0;
error       =   [];
iteration   =   0;

%initialize D using PCA eigenvector
numcomps    =  p;
meanvec     =  mean(X, 2);
meanarray   =  repmat(meanvec, 1, size(X,2));
A           =  X-meanarray;
covA        =  A*A'; 
[V, dia]    =  eig(covA);    %V eigenvector   D eigenvalue
P           =  V(:, (size(V, 2) - numcomps + 1) : size(V, 2));% numcomps eigenvalue minus correspondent eigenvectors
P           =  fliplr(P);
D           =  P;
%initialize D end

while abs(Jnow-Jpre)>Jstep_T  && iteration < Max_iteration
    fprintf(['Metaface:steperror=' num2str(Jnow-Jpre) ';and iteration=' num2str(iteration) '.\n']);
% Fix D 
for i=1:n
    [s,status]    =  l1_ls(D, X(:,i), lambda);
    
    if sum(status=='Solved')~=6
    fprintf('l1 optimation can not get the result!!!');
    end
    
    alpha(:,i)     =  s;
end
%optimation one column by one begin

% Fix alpha, update D. begin
for i=1:p
   ai        =    alpha(i,:);
   Y         =    X-D*alpha+D(:,i)*ai;
   di        =    Y*ai';
   di        =    di./norm(di,2);
   D(:,i)    =    di;
end
% Fix alpha, update D. end

Jpre          =    Jnow;
zz            =    X-D*alpha;zalpha=alpha(:);
Jnow          =    zz(:)'*zz(:)+lambda*sum(abs(zalpha(:)))
iteration     =    iteration+1;
error         =    [error Jnow]

plot(error,'rs');

end

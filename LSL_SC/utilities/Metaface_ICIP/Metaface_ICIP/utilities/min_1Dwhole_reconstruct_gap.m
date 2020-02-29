function [ID,reco_ratio]=min_whole_reconstruct_gap(testdata,testlabels,D,NumClass,lambda)
%output: ID              the recognition result of the test images
%output: reco_ratio      the recognition rate of the test images
%input:  testdata        the test image matrix of m by n by Test_NUM
%input:  testlabels      the test image labels vector of 1 by Test_NUM 


%construct the big dictionary begin
d           =    []; 
labels      =    [];
ID          =    [];

for class   =    1:NumClass
    
    fprintf(['TotalClass:' num2str(NumClass) 'NorClass:' num2str(class)]);
    d       =    [d D(class).d];
    tem     =    D(class).d;
    labels  =    [labels class+zeros(1,size(tem,2))];
    
end
%construct the big dictionary end

%compute the sparse coeff begin
for i  =  1:size(testdata,2)
    
    fprintf(['Totalnum:' num2str(size(testdata,2)) 'Nowprocess:' num2str(i) '\n']);
    [s,status]    =   l1_ls(d, testdata(:,i), lambda);
    
    if sum(status=='Solved')~=6
    fprintf('l1 optimation can not get the result!!!');
    end
    
    gap        =  [];
    
    for j = 1:NumClass
        temp_s   =   zeros(size(s));
        temp_s(find(j==labels))=s(find(j==labels));
        zz       =   testdata(:,i)-d*temp_s;
        gap(j)   =   zz(:)'*zz(:); 
    end
    
    index         =    find(gap==min(gap));
    ID(i)         =    index(1);
end

reco_ratio       =     (sum(ID==testlabels))/length(testlabels);
%compute the sparse coeff end
function [Ic,Oc]=matrix2xcell(Im,Om)
[sizeOm,lengthOm]=size(Om);
Ic=cell(sizeOm,lengthOm);
Oc=cell(sizeOm,lengthOm);
for i=1:sizeOm
    for k=1:lengthOm
    if Om(i,k)==-1
        Om(i,k)= 6; % lamda event
    end
    if Om(i,k)==0
        Om(i,k)=-1; % there is no  output label betwwen the actual state (row)
        % and the the state (idex of actual column)
    end

    end
end
for j=1:numel(Om)
    Oc{j}=Om(j);
    Ic{j}=Im(j);
end

end


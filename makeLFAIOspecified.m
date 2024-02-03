function [Onew] = makeLFAIOspecified(O,Inew)
%  makeLFAIOspecified:	This function changes the matrix I in order to make
%                       the LFAI completely specified.
%
%
%                       ***************************************************
%              
% ## SYNTAX ##
%
%                       [Onew] = makeLFAIOspecified(O,Inew)
%
%                        Given the matrix O, caratteristic of the state
%                        table of a LFAI, and the cardinality of the
%                        transition set, this function returns the same
%                        matrix cell O, with one self-loop labeled epsilon for
%                        all the transition not going out from the older
%                        LFAI automata.
%
%                        

% LFAI's states number
sizeO=numel(O(:,1));
Onew=O;



for i=1:sizeO
    sizeInew=size(Inew{i,i},1);
    if size(Inew{i,i},1)==1
        %Onew{i,i}=0;
        Onew{i,i}=-1;
    else
        Onew{i,i}=[-1];
        for j=2:sizeInew
            
            Onew{i,i}=[Onew{i,i};0];
            
        end
    end
end



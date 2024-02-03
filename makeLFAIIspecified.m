function [Inew] = makeLFAIIspecified(I,nt)
%  makeFSMspecified:	This function changes the matrix I in order to make
%                       the FSM completely specified.
%
%
%                       ***************************************************
%                                       ## SYNTAX ##
%
%                       [Inew] = makeFSMspecified(I,nt)
%
%                        Given the matrix I, caratteristic of the state
%                        table of a FSM, and the cardinality of the
%                        transition set, this function returns the same
%                        matrix cell I, with one self-loop labeled t_i for
%                        all the transition not going out from the older
%                        automata.
%
%                        See also: makeFSM_s, aux_graph, synch_seq_fast
%                        CG_synch.

% FSM's states number
sizeI=numel(I(:,1));
Inew=I;

% Necessary if the cardinality of the transitions set of the PN is UNKNOWN
% 
% % Initializing MAX
% MAX=0;
% 
% % For all the markings belonging to the reachability graph G=R(N,M_0)
% for i=1:sizeI
%     % We check the transitions enabled
%     T=cell2matrix(I(i,:));
%     
%     % reading the max index of those enabled transitions
%     temp=max(T);
% 
%     if temp>MAX
%         MAX=temp;
%     end
% end
% nt=MAX;

% Initializing a transition vector
arc=(1:nt)';

for i=1:sizeI
    % effettuiamo la lettura di tutte le transizioni abilitate.
    TT=nonzeros(cell2matrix(I(i,:)));
    nonout=setdiff(arc,TT);
    if size(I{i,i})==0
        Inew{i,i}=nonout;
    else
        Inew{i,i}=[I{i,i};nonout];
    end
end


end
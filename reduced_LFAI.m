function [RestrictedI]=reduced_LFAI(I)
%  o_aux_graph:   This function computes the reduced I input information of a Labeled Finite
%               State Automaton with Inputs (LFAI)
%
%             ***********************************************************
%                                   ## SYNTAX ##
%               [RestrictedI]=reduced_LFAI(I)

%               "I" concerns all the information related to the Input (without completely specified inputs) .
%               It must be a cell matrix that has as many rows/coloumn as
%               the LFAI's cardinality.
%               The elements I{i,j} gives us the input related to the
%               transition i->j.

RestrictedI={}; % empty reduced structure
[n,~]=size(I);
sink_node_row= cell(1,n);
e=4;                   % Numbrer of event/transition: e_1,e_2...
for i=1:1:n
    sink_node_row{1,i}=[0];
end
%____________________________________________________________________
DeadlockIndex=[];       %the set of index of existed deadlock states
for i=1:1:n
    if  isequal(I(i,1:n),sink_node_row)
        DeadlockIndex=[DeadlockIndex, i];
    else
        %ReducedTrCellMatrix(i, 1:n)=[MatriceTr(i, :)];
        RestrictedI=[RestrictedI; I(i, :)];
        %i=i+1;
    end
end
RestrictedI=[RestrictedI(:,:); sink_node_row]
%_______________________adding arcs to sink node_____________________
[x,y]=size(RestrictedI);
for i=1:1:x
    sink_node_column{i,1}=zeros(1,e);
end
for k=1:1:x
    arcs=[];
    for j=DeadlockIndex
        %if MatriceTr{k,j}~=0
        arcs=[arcs; I{k,j}];
        sink_node_column{k,1}= arcs;
        %end
    end
end
RestrictedI=[RestrictedI(:,:) sink_node_column];
RestrictedI( : ,DeadlockIndex)=[];
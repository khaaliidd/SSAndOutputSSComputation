function [o_graph] =o_aux_graph_v0(Inew,Onew)
%  o_aux_graph_v0:   This function computes the auxiliary graph with outputs of a Labeled Finite
%               State Automaton with Inputs (LFAI) Inew (matrix inputs ), Onew (matrix outputs). (we omit the self-loops)
%
%             ***********************************************************
%                                   ## SYNTAX ##
%               [o_graph] =out_aux_graph(Inew,Onew)
%
%               Given a LFAI, with its state table, this function returns a
%               matrix  cell o_graph that contains for each row:
%
%               1) unordered pair of state of I (s_i s_j);
%               2) the number of arcs outgoing from that couple;
%               3) the triple (s'_i, s'_j, input, output1,output2);.
%         
%                         ________________________________________________________________________
%                        |    1      |       2       |         3                                  |
%                        |___________|_______________|____________________________________________|
%               o_graph= |[s_i, s_j] | #arc outgoing | [[s'_i,s'_j,input], [output1], [output2]]  |
%                        |___________|_______________|____________________________________________|
%
%               ES:
%               Having two transitions arcs t_x:o' and t_y:o" connecting the couple
%               (s_1,s_2) to (s_3,s_3) and (s_1,s_5) respectively, well
%               denote a line such that:
%               -   {[1,2],[2],[[3,3,x],[o_x'],[o_x"]][[1,5,y],[o_y'],[o_y"]]}
%
%               "Inew" concerns all the information related (completely specified) to the Input.
%               It must be a cell matrix that has as many rows/coloumn as 
%               the LFAI's cardinality.
%               The elements I{i,j} gives us the input related to the
%               transition i->j.
%               "Onew" concerns all the information related to the output.
%               It must be a cell matrix that has as many rows/coloumn as 
%               the LFAI's cardinality.
%               The elements O{i,j} gives us the output related to the
%               transition i->j.
%


tic



[sizeI]=size(Inew,1);

% Cardinality of the space state
ns=sizeI;

% Cardinality of the auxiliary graph with outputs
NS= (ns*(ns+1))/2;

% Auxiliary graph with outputs initialization
o_graph=cell(NS,3);
Nodes=zeros(NS,2);



% ***********************************************************************
% Construction of NS nodes (s_i, s_j), which are gonna be put in first  * 
% column                                                                *
% ***********************************************************************

% For i=1...cardinality of state set of G
count=0;
for i=1:ns
    % For j=i...cardinality of state set of G
    for j=i:ns
        % Here, (i,j) is the couple of states s_i,s_j
        count=count+1;
        o_graph{count,1}=[i,j];
        % counter for outgoing arcs
        o_graph{count,2}=0;
        Nodes(count,:)=[i,j];
    end
end


% ***********************************************************************
% Analysing the NS state couples (s_i, s_j) and the corresponding       *
% associated transitions, written in columns 2,3.. :                    *
% ***********************************************************************

% For p=1,2...cardinality of GxG
for p=1:NS
    
    % Here, (i,j) is the couple of states (s_i,s_j),
    % the p-th node of the auxiliary graph GxG
    i=Nodes(p,1);
    j=Nodes(p,2);

    %Initialization of the outgoing arcs from the considered node
    Ti=cell2matrix(Inew(i,:));
    Tj=cell2matrix(Inew(j,:));

    %Initialization of the outgoing arcs from the considered node
    %Oi=cell2matrix(O(i,:));
    %Oj=cell2matrix(O(j,:));
    
    % sizeTi is the MAX cardinality of ingoing arc in the considered states
    [sizeTi,lenghtTi]=size(Ti);
    [sizeTj,lenghtTj]=size(Tj);
    % Ti(1,ii) is the label of state transition s_i -> s_ii
    % Ti(1,jj) is the label of state transition s_j -> s_jj
    for ii=1:sizeTi
        for ww=1:lenghtTi
            % If the label is 0, then we skip it
            if(Ti(ii,ww)~=0)
                for jj=1:sizeTj
                    % Check if there are outgoing arcs from node 2 with
                    % same label of the analyzed one.
                    % If yes, there exists arc labeled Ti(ii,ww) which 
                    % brings to (s_ww,s_arc).
                    % Every entry of "arc" is the index of a state s'_j
                    % such that s_j->s'_j

                    arc=find(Tj(jj,:)==Ti(ii,ww));
                    [sizea,lenghta]=size(arc);
                    
                    if(lenghta~=0)
                        % No shared arcs -> SKIP
                        for kk=1:lenghta
                            % Transition
                            transition=Ti(ii,ww);
                            % states belonging to the reached node
                            iprimo=ww;
                            jprimo=arc(kk);
                            if (iprimo~=i | jprimo~=j)
                            %if([iprimo,jprimo]~=[i,j])& [iprimo,jprimo]~=[j,i]
                                % sorted = ordered couple of states
                                sorted=sort([iprimo,jprimo]);
                     
                                % Saving outgoing arc
                                o_graph{p,2}=o_graph{p,2}+1;
                                Narcsaved=o_graph{p,2};
                                o_graph{p,2+Narcsaved}=[sorted,transition];
                                if (Onew{i,sorted(1)}==-1)
                                    %if (O{j,sorted(2)}==-1)
                                        o_graph{p,2+Narcsaved}=[o_graph{p,2+Narcsaved},Onew(i,sorted(2)), Onew(j,sorted(1))];                                    %else
                                        %o_graph{p,2+Narcsaved}=[o_graph{p,2+Narcsaved},O(i,sorted(2)), O(j,sorted(1))];
                                    %else
                                        %o_graph{p,2+Narcsaved}=[o_graph{p,2+Narcsaved},O(i,sorted(2)), O(j,sorted(1))]; 
                                    %end
                                else
                                       o_graph{p,2+Narcsaved}=[o_graph{p,2+Narcsaved},Onew(i,sorted(1)), Onew(j,sorted(2))];
                                end
                                if (isequal(sorted,[i,j]))
                                    o_graph{p,2+Narcsaved}(2)=[];
                                    o_graph{p,2+Narcsaved}(2)=[];
                                    o_graph{p,2+Narcsaved}=[o_graph{p,2+Narcsaved},Onew(i,sorted(2)), Onew(j,sorted(1))];
                                end
                                


                            end
                        end
                    end
                end
            end
        end
    end    
    
            
    
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % UNCOMMENT THIS if you want the computation  to stop if not done
    %                       within the 3 hour
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        t=toc;  
        if t> 3*60*60
            o_graph=[];
            return
        end   
    end

end
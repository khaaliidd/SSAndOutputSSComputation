
%_______________________ICNSC 2023 Example 1: LFAI (I,O): without presence of deadlocks ______________________________
            
%             %the O{i,j}==-1 gives us the information that i not linked to j 
%             %there is no arc from i->j.
%             O={-1 3 -1 1; 4 -1 1 -1; -1 -1 -1 3; 2 -1 2 -1 }; 
%             
%             %the element I{i,j}==0 gives us the information that i not linked to j
%             %there is no arc from i->j.
%             I={0 1 0 2; 3 0 2 0; 0 0 0 1; 2 0 1 0 }; 
%             
  %_______________________ICNSC 2023 Example 1: LFAI (I,O): without presence of deadlocks ______________________________
            
%             %the O{i,j}==-1 gives us the information that i not linked to j 
%             %there is no arc from i->j.
%             O={-1 3 -1 1; 4 -1 1 -1; -1 -1 -1 3; 2 -1 2 -1 }; 
%             
%             %the element I{i,j}==0 gives us the information that i not linked to j
%             %there is no arc from i->j.
% 
%             I={0 1 0 2; 3 0 2 0; 0 0 0 1; 2 0 1 0 }; 



%_______________________ICSNC 2023 Example 2 : LFAI (I,O): with presence of deadlocks ______________________________

% I= {0 1 0 2 0 0; 3 0 2 0 1 0; 0 0 0 1 3 2; 2 0 1 0 0 3; 0 0 0 0 0 0; 0 0 0 0 0 0};
% %events = {'e_1', 'e_2', 'e_3'};
% Onew={[-1;0] 3 -1 1 [-1;-1]; 4 -1 1 -1 [5;-1]; -1 -1 -1 3 [5;6]; 2 -1 2 -1 [-1;6]; -1 -1 -1 -1 [-1;-1;0;0;0]}; 
% %labels = {'A', 'B', 'C', 'D','E'};

%_______________________ Example 0 : LFAI (I,O): with presence of deadlock ______________________________

% I= {0 1 0; 0 0 1; 0 0 0};
% O={-1 1 -1; -1 -1 2; -1 -1 0};
% Onew={-1 1 -1; -1 -1 2; -1 -1 [-1;0]};

%_______________________ Example 0_v1 : LFAI (I,O): with presence of deadlock ______________________________
% 
 

% Onew1={[-1;0] 1 -1 -1 -1; -1 -1 2 3 -1; -1 -1 [-1;0] -1 4; -1 -1 -1 [-1;0] 5; -1 -1 -1 -1 [-1;0;0] }; 
% %labels = {'A', 'B', 'C', 'D','E'};

%_______________________ Example 0_v2 : LFAI (I,O): with presence of critical state M= [0 0 0 0 2] ______________________________

I= {0 1 0; 0 0 2 ;0 0 0};
%events = {'e_1', 'e_2'};
O={-1 2 -1; -1 -1 4; -1 -1 -1 }; 




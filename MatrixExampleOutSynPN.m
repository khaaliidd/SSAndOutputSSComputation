


%Exemple <

a.transitions=[1 6 7 8];
b.transitions=[3 4 5 11];
c.transitions=[2 9 10];
a.label='e_1';
b.label='e_2';
c.label='e_3';

Inputs=[a b c];
% A.label='A';
% B.label='B';
% C.label='C';
% D.label='D';
% E.label='E';
% F.label='F';
% A.place=[1 2];
% B.place=[4 5];
% C.place=[1 2 3 4];
% D.place=[1 2];
% E.place=6;
% F.place=5;
% %A.fronts=[2 1;1 2;0 1;1 0];
% %B.fronts=[1 0;2 1];
% %C.fronts=[0 1;1 2];
% A.cond=[];
% B.cond=[];
% C.cond=[];
% D.cond=[];
% E.cond=[];
% F.cond=[];
% Outputs=[A B C D E F];


Wpr=[2 0 3 0 1 0 0 0 0 0 0;
    0 1 0 0 1 0 0 1 0 0 0;
    0 0 0 0 0 0 1 0 1 0 1;
    0 0 0 1 0 1 0 0 0 1 0;
    0 0 0 0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0 0 0 0];

Wpo=[0 2 0 3 0 0 0 0 1 0 0;
    1 0 0 0 0 0 0 0 0 0 0;
    0 0 0 0 1 1 0 0 0 0 0;
    0 0 1 0 0 0 1 0 0 0 0;
    0 0 0 0 0 0 0 0 0 1 1;
    0 0 0 0 0 0 0 1 1 0 0];

m0=[3 0 0 0 0 0]';

function [tab_etats,matrice_tr]=reach_graph_pn_V1(Wpr,Wpo,m0,nbre_etats)
% [tab_etats,matrice_tr]=reach_graph_pn_V1(Wpr,Wpo,m0,1000)
% Graphe d'atteignabilité pour les RdP bornés
% tab_etats : liste de tous les états 
% matrice_tr:état i vers j en franchissant la Tr matrice_tr(i,j)
[n,q]=size(Wpr);
% Initialisation
etats=[];
tab_etats=[];
etats_expl=[];
etats_tr=[];
enab=zeros(q,1);
i=1;

%ajout du marquage initial
etats=[etats ;m0'];
tab_etats=[tab_etats; i m0'];

%Boucle principale
while ((i<nbre_etats)&&(isempty(etats)==0))
    
    %prendre le premier element de l'ensemble etats
    m1=etats(1,:)';
    
    %ajouter ce marquage au marquages explorés
    etats_expl=[etats_expl; m1'];
    
    %chercher le degrès d'activation des transitions
    for j=1:q
        I=find(Wpr(:,j)>0);
        enab(j)= min(floor(m1(I(:))./Wpr(I(:),j)));
    end    
    tr_actives=(find(enab>0));
    
    %trouver tous les franchissements possibles (1 seul jeton)
    for k=1:length(tr_actives)
        x=zeros(q,1);
        x(tr_actives(k))=1;        
                
        m=m1+(Wpo-Wpr)*x; %marquage suivant avec le franchissement de la transition k
        
        % Si ce marquage a été exploré ou en attente d'etre explorer
        if ( (sum(ismember(etats_expl,m','rows'))~=0) || (sum(ismember(etats,m','rows'))~=0) )  %donc il a déja été ajouté au tableau des états
            etats_tr = [etats_tr;   find(ismember( (tab_etats(:,2:end)),m1','rows')>0) tr_actives(k) find(ismember(tab_etats(:,2:end),m','rows')>0)];
                        
        else  % Si c'est un nouveau marquage
            %ajouter ce marquage à l'ensemble etats et tableau
            etats=[etats; m'];
            i=i+1;
            tab_etats=[tab_etats; i m'];          
            %ajouter cette transition
            etats_tr = [etats_tr;   find(ismember(tab_etats(:,2:end),m1','rows')>0) tr_actives(k) i];           
        end
    end   
    %enlever le marquage exploré (m1) de l'ensemble etats
    etats(1,:)=[];
end
%Matrice des transitions
matrice_tr=zeros(tab_etats(end,1));
for p=1:length(etats_tr)
    ligne=etats_tr(p,1);
    col=etats_tr(p,3);
    matrice_tr(ligne,col)=etats_tr(p,2);
end
a=tab_etats(3,:);
b=tab_etats(4,:);
tab_etats(3,:)=b;
tab_etats(4,:)=a;
end









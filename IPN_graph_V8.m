function [matrice_tr_inputs,matrice_tr_outputs, new_tab_etats, Outputs, sorties_uniques]=IPN_graph_V8(Wpr,Wpo,m0,tab_etats,matrice_tr,Inputs,Outputs)

nbre_etats=tab_etats(end,1);
nbre_inputs=length(Inputs);
nbre_outputs=length(Outputs);
labeled_tr=[];
nbre_tr=length(Wpr(1,:));
all_tr=[1:nbre_tr];
mark_atteint_lambda=0;
matrice_tr_inputs=matrice_tr.*0;
matrice_tr_outputs=matrice_tr.*0;

for i=1:nbre_inputs
    labeled_tr=[labeled_tr Inputs(i).transitions];
end
lambda_tr=setdiff(all_tr,labeled_tr);  %Transitions labélisées avec lambda


etats_a_explorer=[1];
etats_explores=[];

while (isempty(etats_a_explorer)==0)
    
    i=etats_a_explorer(1);
    %tester si lambda tr validées
    enabled_lambda_tr=ismember(lambda_tr,matrice_tr(i,:));
    if (sum(enabled_lambda_tr)>0)
        while(sum(enabled_lambda_tr)>0) % il y a au moins une tr lambda validé
            enabled_lambda_tr=lambda_tr(find(enabled_lambda_tr>0));
            ii=i;
            for j=1:length(enabled_lambda_tr)
                mark_atteint_lambda=find(matrice_tr(ii,:)==enabled_lambda_tr(j));
                ii=mark_atteint_lambda;
            end
            

            matrice_tr_inputs(i,mark_atteint_lambda)=-1;        
            enabled_lambda_tr=ismember(lambda_tr,matrice_tr(mark_atteint_lambda,:));

            etats_explores = union(etats_explores,i);

            etats_a_explorer=setdiff(etats_a_explorer,i);

            if sum(find(mark_atteint_lambda==etats_explores))==0
                etats_a_explorer = union(etats_a_explorer,mark_atteint_lambda);
            end
            i=mark_atteint_lambda;
        end
    else
        %franchir les labels synchronisés
        for k=1:nbre_inputs
            mark_atteint_label=0;
            ii=i;
            enabled_label_tr=ismember(Inputs(k).transitions,matrice_tr(i,:));
            if sum(enabled_label_tr)>0
                ind=find(enabled_label_tr>0);
                %franchir toutes les transitions de label k
                for j=1:length(ind)
                    mark_atteint_label=find(Inputs(k).transitions(ind(j))==matrice_tr(ii,:));
                    ii=mark_atteint_label;
                end
                if(mark_atteint_label>0)
                    matrice_tr_inputs(i,mark_atteint_label)=k;
                end
                
                % rajouter i aux marquages exploré
                etats_explores = union(etats_explores,i);
                if isempty(mark_atteint_label)==0
                    if sum(find(mark_atteint_label==etats_explores))==0
                        etats_a_explorer = [etats_a_explorer mark_atteint_label];
                    end
                end
            end
        end
        etats_a_explorer(1)=[];
    end
end

len=length(matrice_tr(:,1));
a_supprimer=[];
for i=1:length(matrice_tr(:,1))
    if ( (matrice_tr_inputs(i,:)==zeros(1,len) ) & (matrice_tr_inputs(:,i)'==zeros(1,len)))
        a_supprimer= [a_supprimer i];
    end
end

matrice_tr_inputs(a_supprimer,:)=[];
matrice_tr_inputs(:,a_supprimer)=[];
tab_etats(a_supprimer,:)=[];

len=length(matrice_tr_inputs(:,1));
matrice_tr_outputs=matrice_tr_inputs.*0;
nbr_sorties=length(Outputs);
sorties=zeros(len^2,length(Outputs));

%Génération des sorties
for i=1:len
    for j=1:len
        if (matrice_tr_inputs(i,j) ~= 0)
            matrice_tr_outputs(i,j)=-1;
            etat_precedent=tab_etats(i,2:end);
            etat_suivant=tab_etats(j,2:end);
            for h=1:nbre_outputs
                test=[etat_precedent(Outputs(h).place) etat_suivant(Outputs(h).place)];
                if ismember(test,Outputs(h).fronts,'rows')
                    if isempty(Outputs(h).cond)
                        sorties((j-1)*len+i,h)=1;
                    else
                        if (etat_suivant(Outputs(h).cond(:,1))==Outputs(h).cond(:,2)')
                            sorties((j-1)*len+i,h)=1;
                        end
                    end
                    
                    
                end
            end
        end
        
    end
end
sorties_uniques=sorties;
sorties_uniques=unique(sorties,'rows');
nbr_sorties_actives=sum(sorties_uniques');
a_supp=find(nbr_sorties_actives<=1);
sorties_uniques(a_supp,:)=[];
if(isempty(sorties_uniques)==0)
    for i=1:length(sorties_uniques(:,1))
        indices=find(sorties_uniques(i,:)>0);
        Outputs(nbr_sorties+i).label=[Outputs(indices).label];
        Outputs(end).ci=0;
        Outputs(end).ce=0;
        for k=1:length(indices)
            Outputs(end).ci=Outputs(end).ci+Outputs(indices(k)).ci;
            Outputs(end).ce=Outputs(end).ce+Outputs(indices(k)).ce;
        end
        Outputs(end).place=[];
        Outputs(end).cond=[];
        Outputs(end).fronts=[];
        
    end
end

sorties_uniques=[eye(nbr_sorties); sorties_uniques];

for i=1:len^2
    [oui, num]=(ismember(sorties(i,:),sorties_uniques,'rows'));
    if(oui)
        matrice_tr_outputs(i)=num;
    end
end

new_tab_etats=tab_etats;
col=length(new_tab_etats(:,1));
num=1:col;
num=num';
new_tab_etats(:,1)=num;
end











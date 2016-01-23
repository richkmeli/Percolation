function [Reticolo_AE, Dim_Clus] = Alg_Etichetta_BER (Reticolo_Col)
% Algoritmo Etichetta : Ricerca e numerazione dei cluster in un 
% reticolo colorato, cioè associa ad ogni sito il cluster di appartenenza.
Num_Clus=0;
Dim_Clus=[];
Reticolo_AE=ones(size(Reticolo_Col))*-1;
% per ogni colonna del Reticolo_Col
for col = 1:size(Reticolo_Col)
    %per ogni elemento di colonna del reticolo_col
    for rig = 1:size(Reticolo_Col)
        % se Reticolo_Col è occupato e non visitato aggiungiamo alla coda
        % e visitiamo cluster di appartenenza
        if (Reticolo_AE(rig,col) == -1)
            if (Reticolo_Col(rig,col) == 1)
                Num_Clus=Num_Clus+1;
                Coda_Cluster = [rig col];
                Reticolo_AE(rig,col) = Num_Clus;
                [Reticolo_AE,Coda_Cluster] = Vis_Clus_E_BER(Reticolo_Col, Reticolo_AE, Coda_Cluster, Num_Clus);
                %finito di visitare il cluster si procede con gli altri siti
                Dim_Clus(Num_Clus) = size(Coda_Cluster,1);
            else
                Reticolo_AE(rig,col) = 0;
            end
        end
    end
    
end
    
end
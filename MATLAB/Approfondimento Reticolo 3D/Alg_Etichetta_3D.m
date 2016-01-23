function [Reticolo_AE, Dim_Clus] = Alg_Etichetta_3D (Reticolo_Col)
% Algoritmo Etichetta : Ricerca e numerazione dei cluster in un 
% reticolo colorato, cioè associa ad ogni sito il cluster di appartenenza.
% vettore contenente le dimensioni dei cluster trovati
Dim_Clus = 0;
% numero dei cluster trovati
Num_Clus=0;
% Matrice delle stesse dimensioni del reticolo colorato "Reticolo_Col", in
% cui in ogni sito salviamo l'etichetta identificativa del cluster di appartenenza
Reticolo_AE=zeros(size(Reticolo_Col)+2)-1;
% Metodo alternativo ottimizzante: consiste nel contornare temporaneamente 
% i reticoli con siti non significativi(=0) per evitare i controlli dei siti
% adiacenti( fuori dal range) a quelli disposti sui bordi
dimension = size(Reticolo_AE);
tmp = zeros(dimension);
tmp(2:dimension(1)-1,2:dimension(2)-1,2:dimension(3)-1) = Reticolo_Col;
Reticolo_Col = tmp;          

% per ogni colonna del Reticolo_Col
for z = 2:size(Reticolo_Col,3)-1
for y = 2:size(Reticolo_Col,2)-1
    % per ogni riga(per ogni elemento del vett col) del Reticolo_col
    for x = 2:size(Reticolo_Col,1)-1
        % se Reticolo_Col è occupato e non visitato aggiungiamo alla coda
        % e visitiamo il cluster di appartenenza
        if (Reticolo_AE(x,y,z) == -1)
            if (Reticolo_Col(x,y,z) == 1)
                Num_Clus=Num_Clus+1;
                Coda_Cluster = [x y z];
                Reticolo_AE(x,y,z) = Num_Clus;
                % visita al cluster 
                [Reticolo_AE,Coda_Cluster] = Vis_Clus_E_3D(Reticolo_Col, Reticolo_AE, Coda_Cluster, Num_Clus);
                % Salviamo la dimensione dell'ultimo cluster trovato
                Dim_Clus(Num_Clus+1) = size(Coda_Cluster,1);
                %finito di visitare il cluster si procede con gli altri siti
            else
                Reticolo_AE(x,y,z) = 0;
            end
        end
    end
    
end
end
% rimozione dei siti non significativi(=0)
Reticolo_Col = Reticolo_Col(2:size(Reticolo_Col,1)-1,2:size(Reticolo_Col,2)-1,2:size(Reticolo_Col,3)-1);        
Reticolo_AE = Reticolo_AE(2:size(Reticolo_AE,1)-1,2:size(Reticolo_AE,2)-1,2:size(Reticolo_AE,3)-1);
Dim_Clus(1) = [];
end
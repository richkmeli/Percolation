function  [Reticolo_AE,Coda_Cluster] = Vis_Clus_E_3D(Reticolo_Col, Reticolo_AE, Coda_Cluster, Num_Clus)

% valori utilizzati per calcolare gli indici dei siti adiacenti da visitare
face_index = [-1 0 0; 1 0 0; 0 -1 0; 0 1 0; 0 0 -1; 0 0 1];

i=0;
while i < size(Coda_Cluster,1)
    i = i+1;
    % controllo dei siti adiacenti (sopra,destra...)
    for a=1:6 % ciclo per controllare i siti adiacenti su ogni faccia
        x = Coda_Cluster(i,1) + face_index(a,1);
        y = Coda_Cluster(i,2) + face_index(a,2);
        z = Coda_Cluster(i,3) + face_index(a,3);
        if (Reticolo_AE(x,y,z) == -1)
            if (Reticolo_Col(x,y,z) == 1)
                % accodiamo a Coda_Cluster gli indici del sito visitato
                Coda_Cluster = [Coda_Cluster; x,y,z];
                % Identifichiamo il sito con il numero del cluster di
                % appartenenza
                Reticolo_AE(x,y,z) = Num_Clus;
            else
                Reticolo_AE(x,y,z) = 0;
            end
        end
    end     
end
%scatter3(Coda_Cluster(:,1),Coda_Cluster(:,2),Coda_Cluster(:,3),200,'fill','MarkerEdgeColor','k')
end
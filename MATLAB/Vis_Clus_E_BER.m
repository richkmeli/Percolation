function  [Reticolo_AE,Coda_Cluster] = Vis_Clus_E_BER(Reticolo_Col, Reticolo_AE, Coda_Cluster, Num_Clus)
    %
    % indice massimo per le operazioni sui reticoli
    L = size(Reticolo_Col,1);
    % 
    i=0;
    while i < size(Coda_Cluster,1)
        i = i+1;
        % controllo dei siti adiacenti in senso orario (sopra,destra...)
        
        % indici elemento sopra il sito centrale
        % quando l'elemento centrale è sulla prima riga, evitiamo che venga
        % preso come indice di riga il valore 0 (fuori dal range)
        rig = max([Coda_Cluster(i,1)-1, 1]);
        col = Coda_Cluster(i,2);
        if (Reticolo_AE(rig,col) == -1)
            if (Reticolo_Col(rig,col) == 1)
                % accodiamo a Coda_Cluster gli indici del sito visitato
                Coda_Cluster = [Coda_Cluster; rig, col];
                % Identifichiamo il sito con il numero del cluster di
                % appartenenza
                Reticolo_AE(rig,col) = Num_Clus;
            else
                Reticolo_AE(rig,col) = 0;
            end
        end
        
        % indici elemento destro del sito centrale
        rig = Coda_Cluster(i,1);
        % quando l'elemento centrale è sulla ultima colonna, evitiamo che venga
        % preso come indice di colonna il valore L+1 (fuori dal range)
        col = min([Coda_Cluster(i,2)+1, L]);
        if (Reticolo_AE(rig,col) == -1)
            if (Reticolo_Col(rig,col) == 1)
                % accodiamo a Coda_Cluster gli indici del sito visitato
                Coda_Cluster = [Coda_Cluster; rig, col];
                % Identifichiamo il sito con il numero del cluster di
                % appartenenza
                Reticolo_AE(rig,col) = Num_Clus;
            else
                Reticolo_AE(rig,col) = 0;
            end
        end
        
        % indici elemento inferiore al sito centrale
        % quando l'elemento centrale è sulla ultima riga, evitiamo che venga
        % preso come indice di riga il valore L+1 (fuori dal range) 
        rig = min([Coda_Cluster(i,1)+1, L]);
        col = Coda_Cluster(i,2);
        if (Reticolo_AE(rig,col) == -1)
            if (Reticolo_Col(rig,col) == 1)
                % accodiamo a Coda_Cluster gli indici del sito visitato
                Coda_Cluster = [Coda_Cluster; rig, col];
                % Identifichiamo il sito con il numero del cluster di
                % appartenenza
                Reticolo_AE(rig,col) = Num_Clus;
            else
                Reticolo_AE(rig,col) = 0;
            end
        end
        
        % indici elemento sinistro al sito centrale
        rig = Coda_Cluster(i,1);
        % quando l'elemento centrale è sulla prima colonna, evitiamo che venga
        % preso come indice di colonna il valore 0 (fuori dal range) 
        col = max([Coda_Cluster(i,2)-1, 1]);
        if (Reticolo_AE(rig,col) == -1)
            if (Reticolo_Col(rig,col) == 1)
                % accodiamo a Coda_Cluster gli indici del sito visitato
                Coda_Cluster = [Coda_Cluster; rig, col];
                % Identifichiamo il sito con il numero del cluster di
                % appartenenza
                Reticolo_AE(rig,col) = Num_Clus;
            else
                Reticolo_AE(rig,col) = 0;
            end
        end
        
    end
end
function [Reticolo_AHK, Dim_Clus] = Alg_HK (Reticolo_Col)
% Algoritmo HK : Ricerca e numerazione dei cluster in un 
% reticolo colorato, cioè associa ad ogni sito il cluster di appartenenza.
    [r c] = size(Reticolo_Col);
    Dim_Clus = [];
    Num_Clus= 0; 
    Reticolo_AHK= zeros(r,c);
    
    % lista delle relazioni tra cluster adiacenti
    DimRef_Label( 1:ceil((r*c)/2) ) = 0;
    
    % per ogni colonna del Reticolo_Col
    for col = 1:c
        %per ogni elemento di colonna del reticolo_col
        for rig = 1:r
            % se Reticolo_Col è occupato/colorato
            if (Reticolo_Col(rig,col) == 1)
                % verifichiamo in che situazione ci troviamo tenendo conto
                % anche della situazione agli estremi
                Situaz = 0;
                
                % se non siamo sulla prima colonna controlliamo solo il vicino
                % sinistro
                if col > 1
                    % Etichette degli elemento adiacenti sinistro
                    Label_Sx = Reticolo_AHK(rig,col-1);
                    Situaz = sign(Label_Sx);
                end
                % se non siamo sulla prima riga controlliamo solo il vicino
                % superiore
                if rig > 1
                    % Etichette degli elemento adiacenti superiore
                    Label_Up = Reticolo_AHK(rig-1,col);
                    Situaz = Situaz + 2*sign(Label_Up);
                end

                switch Situaz      
                    % Situaz=0 -> vicini superiore e sinistro non colorati
                    case 0
                        % nuovo cluster. Aumentiamo il numero di cluster
                        % trovati nel reticolo
                        Num_Clus = Num_Clus+1;
                        Reticolo_AHK(rig,col) = Num_Clus;
                        DimRef_Label(Num_Clus) = DimRef_Label(Num_Clus) + 1;
                        
                    % Situaz=1 -> vicini sinistro colorato
                    case 1
                        ref_ok = Label_Sx;
                        while DimRef_Label(ref_ok) < 0
                           ref_ok = -DimRef_Label(ref_ok);
                        end
                        % incrementiamo il contatore del cluster a cui fa
                        % riferimento il vicino
                        DimRef_Label(ref_ok) = DimRef_Label(ref_ok) + 1;
                        % etichettiamo direttamente col riferimento
                        Reticolo_AHK(rig,col) = ref_ok;
                        
                    % Situaz=2 -> vicini superiore colorato
                    case 2
                        ref_ok = Label_Up;
                        while DimRef_Label(ref_ok) < 0
                           ref_ok = -DimRef_Label(ref_ok);
                        end
                        % incrementiamo il contatore del cluster a cui fa
                        % riferimento il vicino
                        DimRef_Label(ref_ok) = DimRef_Label(ref_ok) + 1;
                        % etichettiamo direttamente col riferimento
                        Reticolo_AHK(rig,col) = ref_ok;
                        
                    % Situaz=3 -> vicini superiore e sinistro colorati
                    case 3
                        % cerchiamo ricorsivamente l'etichetta dei cluster
                        % a cui fanno riferimento i vicini                
                        ref_up = Label_Up;
                        ref_sx = Label_Sx;
                        while DimRef_Label(ref_up) < 0
                           ref_up = -DimRef_Label(ref_up);
                        end
                        while DimRef_Label(ref_sx) < 0
                           ref_sx = -DimRef_Label(ref_sx);
                        end
                        
                        % valutazioni sulle etichette trovate nei while
                        if  ref_sx < ref_up % ref SX < ref UP
                            % coloriamo il sito con l'etichetta minore (sx)
                            Reticolo_AHK(rig,col) = ref_sx;
                            % incrementiamo il contatore del cluster della
                            % etichetta minore con il valore del contatore
                            % del cluster dell'etichetta maggiore
                            DimRef_Label(ref_sx) = DimRef_Label(ref_sx) + DimRef_Label(ref_up) + 1;
                            % il contatore dei cluster diventerà quello del
                            % cluster con etichetta minore tra i due
                            DimRef_Label(ref_up) = -ref_sx; 
                            
                        elseif ref_sx > ref_up % ref SX > ref UP
                            Reticolo_AHK(rig,col) = ref_up;
                            DimRef_Label(ref_up) = DimRef_Label(ref_up) + DimRef_Label(ref_sx) + 1;
                            DimRef_Label(ref_sx) = -ref_up;
                            
                        elseif ref_sx == ref_up % SX = UP
                            % coloriamo il sito con l'etichetta del cluster
                            % di riferimento
                            Reticolo_AHK(rig,col) = ref_up;
                            % incrementiamo il contatore del cluster
                            % di riferimento
                            DimRef_Label(ref_up) = DimRef_Label(ref_up) + 1;
                            
                        end
                end
            end
        end
    end
    
    % Manteniamo solo le dimensione del vettore DimRef_Label (eliminando i riferimenti)      
    Dim_Clus = DimRef_Label;
    Dim_Clus(DimRef_Label < 1) = [];
end
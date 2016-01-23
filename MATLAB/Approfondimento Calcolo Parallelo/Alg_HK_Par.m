% Alg_HK_Par.m
function [Reticolo_AHK, Dim_Clus] = Alg_HK_Par(Reticolo)
    % array contenente le dimensioni dei cluster trovati
    Dim_Clus = [];
    % Dimensione del reticolo da visitare
    [r,c] = size(Reticolo);
    % matrice delle etichette dei siti del reticolo
    Reticolo_AHK= zeros(r,c);

    poolobj = gcp(); % controllo che il parallel pool sia avviato
    if isempty(poolobj)
        % Numero di Worker in parallelo
        num_worker = 0;
    else
        % Numero di Worker in parallelo
        num_worker = poolobj.NumWorkers;
    end
    
    % Stima maggiorata del numero di cluster possibile per ogni
    % sottomatrice passata ad un worker
    max_clus_per_subret = ceil(1+(r*c/2)/num_worker);
    max_clus = ceil(1+(r*c/2));
    % lista delle relazioni tra cluster adiacenti
    DimRef_Label(1:num_worker) = new_array(max_clus);
    % array completo delle dimensioni dei cluster e delle relazioni
    DimRef = zeros(max_clus,1);
    
    % etichetta di partenza per ogni worker
    Num_Clus = []; 
    for i=1:num_worker
        Num_Clus(i)= 0 + (i-1)*(max_clus_per_subret-1);
    end
    % numero di colonne che ogni worker deve visitare ed etichettare
    column_per_worker = ceil(c/num_worker);
    % sottomatrici contenenti le etichette (dopo la visita)
    matrix_hk(1:num_worker) = empty_matrix();
    % colonne di inizio e fine da visitare per ogni worker
    c_start(1:num_worker) = 0;
    c_end(1:num_worker) = 0;
    % iniziamo la visita in parallelo sulle sottomatrici
    parfor worker_id=1:num_worker
        % quantità di worker che lavorano ad un numero
        % pieno(column_per_worker) di colonne
        n_full = c - num_worker*(column_per_worker-1);
        % calcoliamo colonna di inizio e colonna finale da visitare
        % all'interno del reticolo
        if worker_id <= n_full   
            c_start(worker_id) = 1 + column_per_worker*(worker_id-1);
            c_end(worker_id) = c_start(worker_id) + column_per_worker - 1;
        else
            c_start(worker_id) = 1 + n_full*column_per_worker + (column_per_worker-1)*(worker_id-n_full-1);
            c_end(worker_id) = c_start(worker_id) + column_per_worker - 2;
        end        
        % copia locale della parte interessata del reticolo
        subret = Reticolo(:,c_start(worker_id):c_end(worker_id));
        subret_hk = zeros(size(subret));

        for col = 1: c_end(worker_id)-c_start(worker_id)+1
           for rig = 1:r
               
                % se subret è occupato/colorato
                if (subret(rig,col) == 1)
                    % verifichiamo in che situazione ci troviamo tenendo conto
                    % anche della situazione agli estremi
                    Situaz = 0;
                    % se non siamo sulla prima colonna controlliamo solo il vicino
                    % sinistro
                    if col > 1
                        % Etichette degli elemento adiacenti sinistro
                        Label_Sx = subret_hk(rig,col-1);
                        Situaz = sign(Label_Sx);
                    end
                    % se non siamo sulla prima riga controlliamo solo il vicino
                    % superiore
                    if rig > 1
                        % Etichette degli elemento adiacenti superiore
                        Label_Up = subret_hk(rig-1,col);
                        Situaz = Situaz + 2*sign(Label_Up);
                    end

                    switch Situaz      
                        % Situaz=0 -> vicini superiore e sinistro non colorati
                        case 0
                            % nuovo cluster. Aumentiamo il numero di cluster
                            % trovati nel reticolo
                            Num_Clus(worker_id) = Num_Clus(worker_id)+1;
                            subret_hk(rig,col) = Num_Clus(worker_id);
                            DimRef_Label(worker_id) = add_in_array(DimRef_Label(worker_id),Num_Clus(worker_id));

                        % Situaz=1 -> vicini sinistro colorato
                        case 1
                            ref_ok = Label_Sx;
                            while get_in_array(DimRef_Label(worker_id),ref_ok) < 0
                               ref_ok = -get_in_array(DimRef_Label(worker_id),ref_ok)
                               %ref_ok = -DimRef_Label(ref_ok);
                            end
                            % incrementiamo il contatore del cluster a cui fa
                            % riferimento il vicino
                            DimRef_Label(worker_id) = add_in_array(DimRef_Label(worker_id),ref_ok);
                            %DimRef_Label(ref_ok) = DimRef_Label(ref_ok) + 1;
                            % etichettiamo direttamente col riferimento
                            subret_hk(rig,col) = ref_ok;

                        % Situaz=2 -> vicini superiore colorato
                        case 2
                            ref_ok = Label_Up;
                            while get_in_array(DimRef_Label(worker_id),ref_ok) < 0
                               ref_ok = -get_in_array(DimRef_Label(worker_id),ref_ok)
                               %ref_ok = -DimRef_Label(ref_ok);
                            end
                            % incrementiamo il contatore del cluster a cui fa
                            % riferimento il vicino
                            DimRef_Label(worker_id) = add_in_array(DimRef_Label(worker_id),ref_ok);
                            % etichettiamo direttamente col riferimento
                            subret_hk(rig,col) = ref_ok;

                        % Situaz=3 -> vicini superiore e sinistro colorati
                        case 3
                            % cerchiamo ricorsivamente l'etichetta dei cluster
                            % a cui fanno riferimento i vicini                
                            ref_up = Label_Up;
                            ref_sx = Label_Sx;
                            while get_in_array(DimRef_Label(worker_id),ref_up) < 0
                               ref_up = -get_in_array(DimRef_Label(worker_id),ref_up)
                            end
                            while get_in_array(DimRef_Label(worker_id),ref_sx) < 0
                               ref_sx = -get_in_array(DimRef_Label(worker_id),ref_sx)
                            end

                            % valutazioni sulle etichette trovate nei while
                            if  ref_sx < ref_up % ref SX < ref UP
                                % coloriamo il sito con l'etichetta minore (sx)
                                subret_hk(rig,col) = ref_sx;
                                % incrementiamo il contatore del cluster della
                                % etichetta minore con il valore del contatore
                                % del cluster dell'etichetta maggiore
                                DimRef_Label(worker_id) = sum_in_array(DimRef_Label(worker_id), ref_sx, get_in_array(DimRef_Label(worker_id),ref_up)+1);
                                % il contatore dei cluster diventerà quello del
                                % cluster con etichetta minore tra i due
                                DimRef_Label(worker_id) = set_in_array(DimRef_Label(worker_id), ref_up, -ref_sx)
                            elseif ref_sx > ref_up % ref SX > ref UP
                                subret_hk(rig,col) = ref_up;
                                DimRef_Label(worker_id) = sum_in_array(DimRef_Label(worker_id), ref_up, get_in_array(DimRef_Label(worker_id),ref_sx)+1);
                                DimRef_Label(worker_id) = set_in_array(DimRef_Label(worker_id), ref_sx, -ref_up)
                            elseif ref_sx == ref_up % SX = UP
                                % coloriamo il sito con l'etichetta del cluster
                                % di riferimento
                                subret_hk(rig,col) = ref_up;
                                % incrementiamo il contatore del cluster
                                % di riferimento
                                DimRef_Label(worker_id) = add_in_array(DimRef_Label(worker_id),ref_up);

                            end
                    end
                end
               
           end
        end
        matrix_hk(worker_id) = matrix(subret_hk);
    end
    
    % ricostruiamo il reticolo delle etichette completo e l'array delle
    % dimensioni e dei riferimenti tra cluster
    for worker_id=1:num_worker
        DimRef = DimRef + get_array(DimRef_Label(worker_id));
        Reticolo_AHK(:,c_start(worker_id):c_end(worker_id)) = get_matrix(matrix_hk(worker_id));
    end

    %controllo bordi tra sub-reticoli per aggiornare i riferimenti
    for worker_id=num_worker-1:-1:1
        for rig=1:r
            % controlliamo solo per i worker che hanno lavorato su almeno
            % una colonna
            if c_end(worker_id) < c
                ref_sx = Reticolo_AHK(rig,c_end(worker_id));
                ref_dx = Reticolo_AHK(rig,c_end(worker_id)+1);
                %se entrambi i siti sono etichettati
                if ref_sx>0 && ref_dx>0 
                    while DimRef(ref_sx) < 0
                       ref_sx = -DimRef(ref_sx);
                    end
                    while DimRef(ref_dx) < 0
                       ref_dx = -DimRef(ref_dx);
                    end

                    if ref_sx ~= ref_dx
                        DimRef(ref_sx) = DimRef(ref_sx) + DimRef(ref_dx);
                        DimRef(ref_dx) = -ref_sx;  
                    end
                end
            end
        end
    end
    % Manteniamo solo le dimensione del vettore DimRef_Label (eliminando i riferimenti)      
    Dim_Clus = DimRef;
    Dim_Clus(DimRef < 1) = [];
end
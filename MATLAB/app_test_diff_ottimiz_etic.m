% test di confronto tra i tempi di calcolo degli algoritmi Etichetta e HK

% numero probabilità
np=11;
% probabilita nel range [0 1]
np_range=linspace(0,1,np);
% numero di tentativi per ogni probabilità-dimensione
tent=20;

dim=[20,30,40,50];

% Matrice dei tempi di esecuzione
% le righe indicano le dimensioni utilizzate
% le colonne indicano le probabilità utilizzate
% la profondita è per i diversi tentativi
Tempi_AE_BER = zeros(4, np, tent);
Tempi_AE_MEL = zeros(4, np, tent);

% Matrici dei tempi medi
Avg_Tempi_AE_BER = zeros(4, np);
Avg_Tempi_AE_MEL = zeros(4, np);



for id=1:size(dim,2)
    d = dim(id);
    % Ciclo sulle probabilità di colorazione (eseguito in prallelo)
    for i=1:np
        % probabilità di colorazione
        p = np_range(i);
        
        for t = 1 : tent
            reticolo = CreaCol_Ret(d,p);
            tic; 
            [ReticoloAE_BER,NumClusAE]=Alg_Etichetta_BER(reticolo);
            Tempi_AE_BER(id, i, t) = toc;
            tic; 
            [ReticoloAE_MEL,NumClusHK]=Alg_Etichetta_MEL(reticolo);  
            Tempi_AE_MEL(id, i, t) = toc;
        end  
        
    end
end

% calcolo della media dei tempi (per ogni coppia probabilita-dimensione)
for id=1:size(dim,2)
    for p=1:np
        Avg_Tempi_AE_BER(id,p) = mean(Tempi_AE_BER(id,p,:));
        Avg_Tempi_AE_MEL(id,p) = mean(Tempi_AE_MEL(id,p,:));
    end
end

figure
hold all
plot(np_range,Avg_Tempi_AE_BER(3,:));
plot(np_range,Avg_Tempi_AE_MEL(3,:));
figure
hold all
plot(dim,Avg_Tempi_AE_BER(:,6));
plot(dim,Avg_Tempi_AE_MEL(:,6));

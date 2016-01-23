% test di confronto tra i tempi di calcolo degli algoritmi Etichetta e HK

% numero probabilità
np=11;
% probabilita nel range [0 1]
np_range=linspace(0,1,np);
% numero di tentativi per ogni probabilità-dimensione
tent=17;
% dimensioni dei reticoli
dimensioni=[37, 73, 107, 137, 173, 199];

% Matrice dei tempi di esecuzione
% le righe indicano le dimensioni utilizzate
% le colonne indicano le probabilità utilizzate
% la profondita è per i diversi tentativi
Tempi_AE = zeros(size(dimensioni,2), np, tent);
Tempi_HK = zeros(size(dimensioni,2), np, tent);

% Matrici dei tempi medi
Avg_Tempi_AE = zeros(size(dimensioni,2), np);
Avg_Tempi_HK = zeros(size(dimensioni,2), np);



% Ciclo sulle dimensioni del reticolo
for n=1:size(dimensioni,2)
    
    dim = dimensioni(1,n);

    % Ciclo sulle probabilità di colorazione (eseguito in prallelo)
    for i=1:np
        % probabilità di colorazione
        p = np_range(i);
        
        for t = 1 : tent
            reticolo = CreaCol_Ret(dim,p);
            tic; [ReticoloAE,NumClusAE] = Alg_Etichetta_MEL(reticolo); Tempi_AE(n,i,t) = toc;
            tic; [ReticoloHK,NumClusHK] = Alg_HK(reticolo); Tempi_HK(n,i,t) = toc;
        end  
        
    end

end


% calcolo della media dei tempi (per ogni coppia probabilita-dimensione)
for d=1:size(dimensioni,2)
    for p=1:np
        Avg_Tempi_AE(d,p) = mean(Tempi_AE(d,p,:));
        Avg_Tempi_HK(d,p) = mean(Tempi_HK(d,p,:));
    end
end

f1 = figure;
f2 = figure;
f3 = figure;
f4 = figure;

% Grafici dei tempi di esecuzione a probabilità fissa (al variare della
% dimensione del reticolo)
% ALGORITMO ETICHETTA
figure(f1);
hold all
for p=1:np
    plot(dimensioni,Avg_Tempi_AE(:,p));
end
hold off
% ALGORITMO H-K
figure(f2);
hold all
for p=1:np
    plot(dimensioni,Avg_Tempi_HK(:,p));
end
hold off

% Grafici dei tempi di esecuzione a dimensione fissa (al variare della
% probabilità di colorazione)
% ALGORITMO ETICHETTA
figure(f3);
hold all
for d=1:size(dimensioni,2)
    plot(np_range,Avg_Tempi_AE(d,:));
end
hold off
% ALGORITMO H-K
figure(f4);
hold all
for d=1:size(dimensioni,2)
    plot(np_range,Avg_Tempi_HK(d,:));
end
hold off

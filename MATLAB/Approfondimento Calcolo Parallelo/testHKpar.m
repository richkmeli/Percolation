% function testHKpar
clear all

% test di confronto tra i tempi di calcolo degli algoritmi Etichetta e HK
% numero probabilità
np=11;
% probabilita nel range [0 1]
np_range=linspace(0,1,np);
% numero di tentativi per ogni probabilità-dimensione
tent=5;
% dimensioni dei reticoli
dimensioni=[101];

% Matrice dei tempi di esecuzione
% le righe indicano le dimensioni utilizzate
% le colonne indicano le probabilità utilizzate
% la profondita è per i diversi tentativi
Tempi_HK = zeros(size(dimensioni,2), np, tent);
Tempi_HKPAR = zeros(size(dimensioni,2), np, tent);

% Matrici dei tempi medi
Avg_Tempi_HK = zeros(size(dimensioni,2), np);
Avg_Tempi_HKPAR = zeros(size(dimensioni,2), np);

% Ciclo sulle dimensioni del reticolo
for n=1:size(dimensioni,2)
    
    dim = dimensioni(1,n);

    % Ciclo sulle probabilità di colorazione (eseguito in prallelo)
    for i=1:np
        % probabilità di colorazione
        p = np_range(i);
        
        for t = 1 : tent
            reticolo = CreaCol_Ret(dim,p);
            tic; [ReticoloHK,NumClusHK] = Alg_HK(reticolo); Tempi_HK(n,i,t) = toc;
            tic; [ReticoloHKPAR,NumClusHKPAR] = Alg_HK_Par(reticolo); Tempi_HKPAR(n,i,t) = toc;
        end  
        
    end

end


% calcolo della media dei tempi (per ogni coppia probabilita-dimensione)
for d=1:size(dimensioni,2)
    for p=1:np
        Avg_Tempi_HK(d,p) = mean(Tempi_HK(d,p,:));
        Avg_Tempi_HKPAR(d,p) = mean(Tempi_HKPAR(d,p,:));
    end
end

% Grafici dei tempi di esecuzione
for d=1:size(dimensioni,2)
    figure(1)
    hold all
    plot(np_range,Avg_Tempi_HK(d,:));
    plot(np_range,Avg_Tempi_HKPAR(d,:));
end

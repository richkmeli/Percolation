% Test sulla Frequenza di Percolazione
clc
clear

% numero probabilit� per ogni dimensione
np=30;
% probabilita nel range [0.05 0.95]
np_range=linspace(0.05,0.95,np);
% numero di tentativi per ogni probabilit�
tent = 1000;

% dimensione reticolo
for dim=[17, 37, 73, 173]
    Freq_Perc = zeros(1,np);
    % numero di tentativi
    for i=1:np
        % probabilit� percolazione
        p = np_range(i);
        perc = zeros(1,tent);
        
        % i casi limite con 0 e 1 sappiamo che descivono rispettivamente
        % l'assenza di percolazione e la presenza
        for t = 1 : tent
            Reticolo=CreaCol_Ret(dim,p);
            [Reticolo_AE, Dim_Clus] = Alg_Etichetta_MEL(Reticolo);
            if Ricer_Percol(Reticolo_AE) ~= 0
                 Freq_Perc(i) = Freq_Perc(i) + 1;
                 perc(t) = 1;
            end
        end
        % CALCOLO FREQUENZA DI PERCOLAZIONE (vPerc)
        Freq_Perc(i) = Freq_Perc(i)/tent;
        % CALCOLO DELL'ERRORE (associato ad ogni probabilit� p)
        % mediante funzione matlab 'std' che ritorna la deviazione standard
        Err_Freq_Perc(i) = std(perc)/sqrt(tent);
    end
    
    % GRAFICO
    hold all
    errorbar(np_range,Freq_Perc,Err_Freq_Perc);
end

hold off
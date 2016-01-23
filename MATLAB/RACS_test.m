% RACS TEST CON PROVE IN PARALLELO
clc
clear all

% numero probabilità
np=30;
% probabilita nel range [0.01 1]
np_range=linspace(0.01,1,np);
% numero di tentativi per ogni probabilità
tent = 1000;

% dimensione reticolo
for dim=[ 37, 73, 107, 173]
    % numero di tentativi parallelizzati
    parfor i=1:np 
        p = np_range(i); 
        
        RACS = zeros(1,tent);
        p1 = zeros(1,tent);
        p2 = zeros(1,tent);
        p3 = zeros(1,tent);
        % i casi limite con 0 e 1 sappiamo che descivono rispettivamente
        % l'assenza di percolazione e la presenza
        for t = 1 : tent
            Reticolo=CreaCol_Ret(dim,p);
            [Reticolo_AHK,  Dim_Clus] = Alg_HK(Reticolo);
            % tmp è Dim_Clus senza il valore massimo
            tmp = Dim_Clus;
            [valmax,index] = max(Dim_Clus);
            tmp(index) = [];
            % Racs sulla singola prova
            RACS(t) = sum(tmp.^2)/sum(Dim_Clus);
            
            p1(t) = max(Dim_Clus)/(dim^2);
            p2(t) = p1(t)/p;
            p3(t) = max(Dim_Clus)/sum(Dim_Clus);
            
            situazione = [dim,p,t] % tentativo in cui siamo
            disp(situazione)
        end
        % MEDIA del RACS e relativo ERRORE per ogni probabilità
        Avg_RACS(i) = mean(RACS);
        Err_RACS(i) = std(RACS)/sqrt(tent);
        
        Avg_P1(i) = mean(p1);
        Err_P1(i) = std(p1)/sqrt(tent);
        Avg_P2(i) = mean(p2);
        Err_P2(i) = std(p2)/sqrt(tent);
        Avg_P3(i) = mean(p3);
        Err_P3(i) = std(p3)/sqrt(tent);
    end
    
    % GRAFICO
    figure(1)
    hold all
    errorbar(np_range,Avg_RACS,Err_RACS,'-');
    figure(2);
    hold all
    errorbar(np_range,Avg_P1,Err_P1,'-');
    figure(3)
    hold all
    errorbar(np_range,Avg_P2,Err_P2,'-');
    figure(4)
    hold all
    errorbar(np_range,Avg_P3,Err_P3,'-');
    
end

hold off
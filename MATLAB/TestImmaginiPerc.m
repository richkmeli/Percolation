clear all
clc
% numero probabilità per ogni dimensione
np=9;
% probabilita nel range [0.1 0.9]
np_range=linspace(0.1,0.9,np);

for zi=1:np
    % probabilità percolazione
    p = np_range(zi);
    Reticolo=CreaCol_Ret(30,p);
    [Reticolo_AE, Dim_Clus] = Alg_Etichetta_MEL(Reticolo);
    [Clus_perc] = Ricer_Percol(Reticolo_AE);
    Reticolo = double(Reticolo);
    for i= 1:size(Reticolo,1)
        for j= 1:size(Reticolo,1)
            if (Reticolo_AE(i,j) == Clus_perc)
                Reticolo(i,j) = 0.5;
            end
        end
    end
     Reticolo(30,30) = 1;
    subplot(3,3,zi)
    surf(Reticolo);
    view(2)
end
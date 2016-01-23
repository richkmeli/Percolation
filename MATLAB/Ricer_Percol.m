function  [clus_perc] = Ricer_Percol(Reticolo_AE)
    %
    dim_lato=size(Reticolo_AE);
    % prima e ultima colonna del reticolo
    c1= Reticolo_AE(1:dim_lato,1);
    cend= Reticolo_AE(1:dim_lato,dim_lato);
    
    clus_perc = 0;
    for i= 1:length(c1)
        for j= 1:length(cend)
            if (c1(i) == cend(j) && c1(i) ~= 0)
                clus_perc = [clus_perc , c1(i)];
            end
        end
    end
    if length(clus_perc) > 1
    % toglie zero iniziale e elementi ripetuti
    clus_perc = unique(clus_perc(2:length(clus_perc)));
    end
end
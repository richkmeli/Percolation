function  [clus_perc] = Ricer_Percol(Reticolo_AE)
    %
    dim_lato=size(Reticolo_AE);
    % prima e ultima faccia del reticolo 3d
    first_face = Reticolo_AE(1:dim_lato, 1:dim_lato, 1);
    last_face = Reticolo_AE(1:dim_lato, 1:dim_lato, dim_lato);
    
    clus_perc = 0;
    for i= 1:size(first_face,1)
        for j= 1:size(first_face,2)
            for r= 1:size(last_face,1)
        	for m= 1:size(last_face,2)
			if (first_face(i,j) == last_face(r,m) && first_face(i,j) ~= 0)
                		clus_perc = [clus_perc , first_face(i,j)];
            		end
		end
	    end
        end
    end

    if length(clus_perc) > 1
    % toglie zero iniziale e elementi ripetuti
    clus_perc = unique(clus_perc(2:length(clus_perc)));
    end
end
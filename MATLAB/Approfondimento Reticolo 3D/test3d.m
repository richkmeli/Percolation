
% Test sulla frequenza di percolazione su un reticolo di 3-dimensioni
clear
clc
% numero probabilità
np=30;
% probabilita nel range [0.05 0.95]
np_range=linspace(0.05,0.95,np);
% numero di tentativi per ogni probabilità
tent = 400;

% dimensione reticolo
for dim=[10,20,30]
    Freq_Perc = zeros(1,np);
    % numero di tentativi parallelizzati
    parfor i=1:np
        % probabilità di colorazione
        p = np_range(i);
        perc = zeros(1,tent);
        
        % i casi limite con 0 e 1 sappiamo che descivono rispettivamente
        % l'assenza di percolazione e la presenza certa
        for t = 1 : tent
            Reticolo=CreaCol_Ret3D(dim,p);
            [Reticolo_AE, Dim_Clus] = Alg_Etichetta_3D(Reticolo);
            if Ricer_Percol3D(Reticolo_AE) ~= 0
                 Freq_Perc(i) = Freq_Perc(i) + 1;
                 perc(t) = 1;
            end
        end
        % CALCOLO FREQUENZA DI PERCOLAZIONE (vPerc)
        Freq_Perc(i) = Freq_Perc(i)/tent;
        % CALCOLO DELL'ERRORE (associato ad ogni probabilità p)
        % mediante funzione matlab 'std' che ritorna la deviazione standard
        Err_Freq_Perc(i) = std(perc)/sqrt(tent);
    end
    
    % GRAFICO
    hold all
    errorbar(np_range,Freq_Perc,Err_Freq_Perc);
end

hold off


% p = [0.1 0.2 0.3 0.4 0.5 0.6];
% np = length(p);
% pos=0;
% figure
% for i = 1:np
%     pos = pos+1;
%     
%     ret = CreaCol_Ret3D(10,p(i));
%     [retet, dim] = Alg_Etichetta_3D(ret);
%     [perc] = Ricer_Percol3D(retet);
% 
%     %trovo gli indici dei siti occupati
%     idx = find(ret > 0);
% 
%     %grafico del reticolo3d
% 
%     subplot(np,2,pos);
%     [F,V,C] = ind2patch(idx,retet,'vu');
%     title('Cluster appartenenti al reticolo p=');
%     xlabel('X');ylabel('Y'); zlabel('Z'); hold on;
%     patch('Faces',F,'Vertices',V,'FaceColor','flat','CData',C,'EdgeColor','k','FaceAlpha',0.5);
%     axis equal; view(3); axis tight; axis vis3d; grid on; box on; axis([0 11 0 11 0 11]);
%     drawnow;
% 
%     pos = pos+1;
%     if perc~= 0
%         subplot(np,2,pos);
%         idx = find(retet == perc(1));
%         [F,V,C] = ind2patch(idx,retet,'v');
%         title('Cluster percolante');
%         xlabel('X');ylabel('Y'); zlabel('Z'); hold on;
%         patch('Faces',F,'Vertices',V,'FaceColor','flat','CData',C,'EdgeColor','k','FaceAlpha',0.5);
%         axis equal; view(3); axis tight; axis vis3d; grid on; box on; axis([0 11 0 11 0 11]);
%         drawnow;
%     end
% end
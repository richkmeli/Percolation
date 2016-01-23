function [Reticolo_Col] = CreaCol_Ret (dim , Prob_Col)
% Creazione e colorazione del reticolo con lato di dimensione "dim" con
% probabilit� di colorazione "Prob_Col"
    Reticolo_Col = rand(dim) < Prob_Col;
end
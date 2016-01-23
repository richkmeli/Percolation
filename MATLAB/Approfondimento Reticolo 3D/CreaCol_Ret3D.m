function [Reticolo_Col] = CreaCol_Ret3D (dim, Prob_Col)
% Creazione e colorazione del reticolo con lato di dimensione "dim" con
% probabilità di colorazione "Prob_Col"
    Reticolo_Col = rand(dim,dim,dim) < Prob_Col;
end
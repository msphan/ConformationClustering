function Points = Genere_Points(file_name)

[PDBdata] = pdb2mat(file_name);
file_size = size(PDBdata.resNum,2);

n_AA = 1;
i=1;
while n_AA<=PDBdata.resNum(1,i+1) % compte le nombre d'acides aminés
    n_AA = PDBdata.resNum(1,i);
    i = i + 1;
end


num_config = 0;
num_AA = 2;
num_atom = 0;
X = 0;
Y = 0;
Z = 0;

for i=1:file_size
    if num_AA>PDBdata.resNum(1,i)
        num_config = num_config + 1;
    end
    num_AA = PDBdata.resNum(1,i);
    if i<file_size
        if PDBdata.resNum(1,i+1)==num_AA
            X = X + PDBdata.X(1,i);
            Y = Y + PDBdata.Y(1,i);
            Z = Z + PDBdata.Z(1,i);
            num_atom = num_atom + 1;
        else
            Points(num_config, num_AA, :) = [X, Y, Z]/num_atom;
            num_atom = 0;
            X = 0;
            Y = 0;
            Z = 0;
        end
    else
        Points(num_config, num_AA, :) = [X, Y, Z]/num_atom;
        num_atom = 0;
        X = 0;
        Y = 0;
        Z = 0;
    end
end

function Objet = Genere3D_pdb(namefile, dim, dm, Option, p, affichage)

% Author: Yves-Michels
% génère un objet 3d de la protéine namefile.
% dm définit la dimension des acides aminés, la taille en pixel est donnée
% par dim/dm
% Option correspond au choix de représentation : 
%       '1' Gaussienne
%       '2' Binaire
% p : paramètre de déformation entre 0 et 1
% affichage : '0' ne rien afficher, '1' afficher l'objet (long en temps de
% calcul)

%   namefile = 'movie.txt'; dim = 150 ; dm = 15; plan = 2; Option = 1;
%
%     == EXEMPLE ==
% Objet = Genere3D_pdb('movie2_cdk2.txt', 100, 15, 1, 0, 1);


Points = Genere_Points(namefile);
[n_config, n_AA, useless] = size(Points);
m = min(min(min(Points)));
Points = (Points - m)*0.8/(max(max(max(Points))) - m) + 0.1;

dot = zeros(floor(dim/dm), floor(dim/dm), floor(dim/dm));
for i=1:floor(dim/dm)
    for j=1:floor(dim/dm)
        for k=1:floor(dim/dm)
            if ((i-dim/(2*dm))^2 + (j-dim/(2*dm))^2 + (k-dim/(2*dm))^2 )< (dim/(2*dm))^2
                if Option==2
                    dot(i,j,k) = 1;
                else

                    dot(i,j,k) = 1;%exp(-6*dm*dm((i-dim/(2.2*dm))^2 + (j-dim/(2.2*dm))^2 + (k-dim/(2.2*dm))^2 )/(dim*dim));
                    
                   
                end
            end
        end
    end
end

    
Objet = zeros(dim, dim, dim);
Pts = squeeze(Points(floor(p*(n_config-1)+1),:,:)*( 1 - p*(n_config-1) + floor(p*(n_config-1)) ) + Points(min(floor(p*(n_config-1)+2), n_config),:,:)*( p*(n_config-1) - floor(p*(n_config-1)) ));
%     figure(246),
%     scatter3(Pts(:,1),Pts(:,2),Pts(:,3));
for j=1:n_AA
    ii = round(dim*Pts(j,1));
    jj = round(dim*Pts(j,2));
    kk = round(dim*Pts(j,3));
    for k=1:floor(dim/dm)
        for l=1:floor(dim/dm)
            for m=1:floor(dim/dm)
                if ii+k-floor(dim/(2*dm))>0 && ii+k-floor(dim/(2*dm))<=dim && jj+l-floor(dim/(2*dm))>0 && jj+l-floor(dim/(2*dm))<=dim && kk+m-floor(dim/(2*dm))>0 && kk+m-floor(dim/(2*dm))<=dim
                    
                    Objet(ii+k-floor(dim/(2*dm)),jj+l-floor(dim/(2*dm)),kk+m-floor(dim/(2*dm))) = dot(k,l,m);
                    
                end
            end
        end
    end
end

if affichage==1
    theta = 1;
    phi = 1;
    psi = 1;
    for i=1:60
        theta = theta + 0.02*cos(i/100);
        phi = phi + 0.02*sin(i/100);
        psi = psi + 0.005*sin(i/150);
        [Im2, ImR] = ImageObjet(Objet, theta, phi, psi, 3*ones(dim, dim, dim));
        figure(134),
        hold off,
        imshow(Im2);
    end
end

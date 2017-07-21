function [Im2, ImR] = ImageObjet(Im, theta, phi, psi, ImType)


dim      = size(Im,1);              
cc     = floor((dim+1)/2);
ImR = zeros(dim+1,dim+1);
dim2 = 2*dim;
ImIn = imresize(im2double(imread('Fond.jpg')),[floor(1.1*dim2) floor(dim2*4/3)]);
Fond = zeros(dim2, floor(dim2*4/3), 3);
Fond(1:floor(0.6*dim2),:,:) = ImIn(1:floor(0.6*dim2),:,:);
Fond(floor(0.6*dim2)+1:dim2,:,:) = ImIn(floor(1.1*dim2)-dim2+floor(0.6*dim2)+1:floor(1.1*dim2),:,:);
Fond(:,:,1:2) = 0.4*Fond(:,:,1:2);
Fond(:,:,3) = 0.5*Fond(:,:,3);
if nargin==4

    theta = theta;
    phi = phi;
    psi = psi;

    cosTheta = cos(theta);
    sinTheta = sin(theta);
    cosPhi   = cos(phi);
    sinPhi   = sin(phi);
    cosPsi   = cos(psi);
    sinPsi   = sin(psi);

    crts2sphr  = [            cosTheta*cosPhi                          sinTheta*cosPhi                         sinPhi    ;...    
                  -sinTheta*cosPsi+cosTheta*sinPhi*sinPsi     cosTheta*cosPsi+sinTheta*sinPhi*sinPsi     -cosPhi*sinPsi  ;....
                  -sinTheta*sinPsi-cosTheta*sinPhi*cosPsi     cosTheta*sinPsi-sinTheta*sinPhi*cosPsi      cosPhi*cosPsi  ];

    for i=1:dim
        for j=1:dim
            for k=1:dim
                P = crts2sphr*[i-cc j-cc k-cc]';     % P = [r u v], (u,v) étant le plan image
                % coordonnées entières (sur la grille de pixels) de la
                % projection du point (i,j,k) sur le plan image
                fu = floor(P(2));
                fv = floor(P(3));
                if fu+cc>0 && fu+cc<dim+2 && fv+cc>0 && fv+cc<dim+2
                    if Im(i,j,k)>0 && dim+P(1)>ImR(fu+cc,fv+cc)
                        ImR(fu+cc,fv+cc) = P(1)+dim; % 
                    end
                end
                if fu+cc+1>0 && fu+cc+1<dim+2 && fv+cc>0 && fv+cc<dim+2
                    if Im(i,j,k)>0 && dim+P(1)>ImR(fu+cc+1,fv+cc)
                        ImR(fu+cc+1,fv+cc) = P(1)+dim; % 
                    end
                end
                if fu+cc>0 && fu+cc<dim+2 && fv+cc+1>0 && fv+cc+1<dim+2
                    if Im(i,j,k)>0 && dim+P(1)>ImR(fu+cc,fv+cc+1)
                        ImR(fu+cc,fv+cc+1) = P(1)+dim; % 
                    end
                end
                if fu+cc+1>0 && fu+cc+1<dim+2 && fv+cc+1>0 && fv+cc+1<dim+2
                    if Im(i,j,k)>0 && dim+P(1)>ImR(fu+cc+1,fv+cc+1)
                        ImR(fu+cc+1,fv+cc+1) = P(1)+dim; % 
                    end
                end
            end
        end
    end
    Max = max(max(ImR.^2));
    Im2 = sqrt( (ImR(1:dim,1:dim)-ImR(2:dim+1,1:dim)).^2 + (ImR(1:dim,1:dim)-ImR(1:dim,2:dim+1)).^2);
    Im2 = min((0.7*(Im2+1).^-1+0.3).*ImR(1:dim,1:dim).^2/Max,1);

    % for i=1:dim
    %     for j=1:dim
    %         if ImR(i,j) == 0
    %             Im2(i,j) = 0;
    %         end
    %     end
    % end
else
    Im2 = zeros(dim, dim, 3);
    theta = theta;
    phi = phi;
    psi = psi;

    cosTheta = cos(theta);
    sinTheta = sin(theta);
    cosPhi   = cos(phi);
    sinPhi   = sin(phi);
    cosPsi   = cos(psi);
    sinPsi   = sin(psi);

    crts2sphr  = [            cosTheta*cosPhi                          sinTheta*cosPhi                         sinPhi    ;...    
                  -sinTheta*cosPsi+cosTheta*sinPhi*sinPsi     cosTheta*cosPsi+sinTheta*sinPhi*sinPsi     -cosPhi*sinPsi  ;....
                  -sinTheta*sinPsi-cosTheta*sinPhi*cosPsi     cosTheta*sinPsi-sinTheta*sinPhi*cosPsi      cosPhi*cosPsi  ];

    for i=1:dim
        for j=1:dim
            for k=1:dim
                P = crts2sphr*[i-cc j-cc k-cc]';     % P = [r u v], (u,v) étant le plan image
                % coordonnées entières (sur la grille de pixels) de la
                % projection du point (i,j,k) sur le plan image
                fu = floor(P(2));
                fv = floor(P(3));
                if ImType(i,j,k)==0
                    % couleur = 0.8*[1 1.2 1.6]; % bleu brillant
                    couleur = [0 0.5 1]; % bleu
                end
                if ImType(i,j,k)==1
                    % couleur = 0.8*[1.8 1 1]; % rouge brillant
                    couleur = [1 0 0]; % rouge
                end
                if ImType(i,j,k)==2
                    % couleur = 0.8*[1.7 1.4 1]; % orange brillant
                    couleur = [1 0.6 0]; % orange
                end
                if ImType(i,j,k)==3
                    % couleur = 0.8*[1.7 1.7 1]; % jaune brillant
                    couleur = [1 1 0.3]; % jaune
                end
                if fu+cc>0 && fu+cc<dim+1 && fv+cc>0 && fv+cc<dim+1
                    if Im(i,j,k)>0 && dim+P(1)>ImR(fu+cc,fv+cc)
                        ImR(fu+cc,fv+cc) = P(1)+dim; % 
                        Im2(fu+cc,fv+cc,:) = couleur;
                    end
                end
                if fu+cc+1>0 && fu+cc+1<dim+1 && fv+cc>0 && fv+cc<dim+1
                    if Im(i,j,k)>0 && dim+P(1)>ImR(fu+cc+1,fv+cc)
                        ImR(fu+cc+1,fv+cc) = P(1)+dim; % 
                        Im2(fu+cc+1,fv+cc,:) = couleur;
                    end
                end
                if fu+cc>0 && fu+cc<dim+1 && fv+cc+1>0 && fv+cc+1<dim+1
                    if Im(i,j,k)>0 && dim+P(1)>ImR(fu+cc,fv+cc+1)
                        ImR(fu+cc,fv+cc+1) = P(1)+dim; % 
                        Im2(fu+cc,fv+cc+1,:) = couleur;
                    end
                end
                if fu+cc+1>0 && fu+cc+1<dim+1 && fv+cc+1>0 && fv+cc+1<dim+1
                    if Im(i,j,k)>0 && dim+P(1)>ImR(fu+cc+1,fv+cc+1)
                        ImR(fu+cc+1,fv+cc+1) = P(1)+dim; % 
                        Im2(fu+cc+1,fv+cc+1,:) = couleur;
                    end
                end
            end
        end
    end
    Max = max(max((ImR).^2));
    for i=1:3
        Im2(:,:,i) = Im2(:,:,i).*(0.7*(sqrt( (ImR(1:dim,1:dim)-ImR(2:dim+1,1:dim)).^2 + (ImR(1:dim,1:dim)-ImR(1:dim,2:dim+1)).^2)+1).^-1+0.3);
        Im2(:,:,i) = max(min(Im2(:,:,i).*(ImR(1:dim,1:dim)).^2/Max,1),0);
    end
    Im2 = min(max(imresize(Im2,[dim2 dim2]),0),1);
    Seuil = 0.02;
    ImB = Im2;
    Im2 = zeros(dim2,floor(dim2*4/3),3);
    Im2(:,1+floor(dim2/6):floor(dim2/6)+dim2,:) = ImB;
    Im2(:,1:floor(dim2/6),:) = Fond(:,1:floor(dim2/6),:);
    Im2(:,floor(dim2/6)+dim2+1:end,:) = Fond(:,floor(dim2/6)+dim2+1:end,:);
    for i=1:dim2
        for j=1+floor(dim2/6):dim2+floor(dim2/6)
            if (Im2(i,j,1)^2+Im2(i,j,2)^2+Im2(i,j,3)^2)<Seuil
                Im2(i,j,:) = Fond(i,j,:);
            else
                if i>1 && i<dim2+1 && j>1 && j<dim2+1
                    if (Im2(i-1,j,1)^2+Im2(i-1,j,2)^2+Im2(i-1,j,3)^2)<Seuil || (Im2(i,j+1,1)^2+Im2(i,j+1,2)^2+Im2(i,j+1,3)^2)<Seuil || (Im2(i-1,j,1)^2+Im2(i-1,j,2)^2+Im2(i-1,j,3)^2)<Seuil || (Im2(i,j-1,1)^2+Im2(i,j-1,2)^2+Im2(i,j-1,3)^2)<Seuil
                        Im2(i,j,:) = 0.3*Im2(i,j,:) + 0.7*Fond(i,j,:);
                    end                    
                end
            end
        end
    end
  
end

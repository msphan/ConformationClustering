function [Projections, Verite_terrain] = GenereProjections_pdb(namefile, n_proj, dim, dm, plan, Option, Range)
% génère n_proj projections de dimension sqrt(2)*dim de la protéine
% namefile.
% dm définit la dimension des acides aminés, la taille en pixel est donnée
% par dim/dm
% plan corrspond au plan d'observation de l'objet 3d pour dénérer les
% images.
% Option correspond au choix de représentation : 
%       '1' représentation ''visuelle''
%       '2' projection 2d de l'objet 3d
%       '3' ombre

%   namefile = 'movie.txt'; dim = 150 ; dm = 15; plan = 2; Option = 1;
%[Projections, Verite_terrain] = GenereProjections_pdb('movie2_cdk2.txt', 5000, 150, 15, 1, 1, [0, -1]);


if nargin==6
    Range = [0; 1];
end
Points = Genere_Points(namefile);
[n_config, n_AA, useless] = size(Points);
m = min(min(min(Points)));
Points = (Points - m)*0.8/(max(max(max(Points))) - m) + 0.1;

dot = zeros(floor(dim/dm),floor(dim/dm));
for i=1:floor(dim/dm)
    for j=1:floor(dim/dm)
        if ((i-dim/(2*dm))^2+(j-dim/(2*dm))^2)< (dim/(2*dm))^2
            if Option==3
                dot(i,j) = 1;
            else
                dot(i,j) = exp(-6*dm*dm*((i-dim/(2.2*dm))^2+(j-dim/(2.2*dm))^2)/(dim*dim));
            end
        end
    end
end

Imax = 41;
for i=1:Imax
    p = ( abs(Range(2)) - abs(Range(1)) )*(i-1)/(Imax+1) + abs(Range(1));
    
    Im = zeros(dim,dim);
    H = zeros(dim,dim);
    Pts = squeeze(Points(floor(p*(n_config-1)+1),:,:)*( 1 - p*(n_config-1) + floor(p*(n_config-1)) ) + Points(min(floor(p*(n_config-1)+2), n_config),:,:)*( p*(n_config-1) - floor(p*(n_config-1)) ));
%     figure(246),
%     scatter3(Pts(:,1),Pts(:,2),Pts(:,3));
        for j=1:n_AA
            ii = round(dim*Pts(j,mod(plan,3)+1));
            jj = round(dim*Pts(j,mod(plan+1,3)+1));
            for k=1:floor(dim/dm)
                for l=1:floor(dim/dm)
                    if dot(k,l)>0 && ii+k-floor(dim/(2*dm))>0 && ii+k-floor(dim/(2*dm))<=dim && jj+l-floor(dim/(2*dm))>0 && jj+l-floor(dim/(2*dm))<=dim && H(ii+k-floor(dim/(2*dm)),jj+l-floor(dim/(2*dm))) < 0.3+dot(k,l)/dm + Pts(j,plan)
                        if Option==1 || Option==3
                            Im(ii+k-floor(dim/(2*dm)),jj+l-floor(dim/(2*dm))) = dot(k,l);
                            H(ii+k-floor(dim/(2*dm)),jj+l-floor(dim/(2*dm))) = 0.3 + dot(k,l)/dm + Pts(j,plan);
                        end
                        if Option==2 % projection
                            Im(ii+k-floor(dim/(2*dm)),jj+l-floor(dim/(2*dm))) = Im(ii+k-floor(dim/(2*dm)),jj+l-floor(dim/(2*dm))) + 0.1*dot(k,l);
                        end
                    end
                end
            end
        end
        if Option==1
            Im = Im.*H;
        end
%         figure(547),
%         imagesc(H,[0 1.3]);
        figure(355),
        hold off,
        imshow(Im);
        axis off,
        pause(0.1);
        
        if mod((i-1),10)==0
            figure(171+i),
            %subplot(2,3,1+floor((i-1)/10)),
            hold off,
            imagesc(sqrt(Im));
            axis off,
        end
end

if Range(2)>0
    for i=1:n_proj
        pp = rand();
        p = (Range(2)-Range(1))*pp + Range(1);
        a = 360*rand();

        Im = zeros(dim,dim);
        H = zeros(dim,dim);
        Pts = squeeze(Points(floor(p*(n_config-1)+1),:,:)*( 1 - p*(n_config-1) + floor(p*(n_config-1)) ) + Points(min(floor(p*(n_config-1)+2), n_config),:,:)*( p*(n_config-1) - floor(p*(n_config-1)) ));
    %     figure(246),
    %     scatter3(Pts(:,1),Pts(:,2),Pts(:,3));
            for j=1:n_AA
                ii = round(dim*Pts(j,mod(plan,3)+1));
                jj = round(dim*Pts(j,mod(plan+1,3)+1));
                for k=1:floor(dim/dm)
                    for l=1:floor(dim/dm)
                        if dot(k,l)>0 && ii+k-floor(dim/(2*dm))>0 && ii+k-floor(dim/(2*dm))<=dim && jj+l-floor(dim/(2*dm))>0 && jj+l-floor(dim/(2*dm))<=dim && H(ii+k-floor(dim/(2*dm)),jj+l-floor(dim/(2*dm))) < 0.3+dot(k,l)/dm + Pts(j,plan)
                            if Option==1 || Option==3
                                Im(ii+k-floor(dim/(2*dm)),jj+l-floor(dim/(2*dm))) = dot(k,l);
                                H(ii+k-floor(dim/(2*dm)),jj+l-floor(dim/(2*dm))) = 0.3 + dot(k,l)/dm + Pts(j,plan);
                            end
                            if Option==2 % projection
                                Im(ii+k-floor(dim/(2*dm)),jj+l-floor(dim/(2*dm))) = Im(ii+k-floor(dim/(2*dm)),jj+l-floor(dim/(2*dm))) + 0.1*dot(k,l);
                            end
                        end
                    end
                end
            end
            if Option==1
                Im = Im.*H;
            end
            Projections(i,:) = radon(Im,a)';
            Verite_terrain(i,1) = a;
            Verite_terrain(i,2) = pp;
    %         figure(547),
    %         imagesc(H,[0 1.3]);
        if mod(i,50)==0
                figure(355),
                hold off,
                imshow(Im);
                axis off,
        %        pause(0.5);
            i
        end
    end
else
    Projections = 0;
    Verite_terrain = 0;
end

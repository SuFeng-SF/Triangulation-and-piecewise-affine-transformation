function [imgBReg, RegtriEsti] = ImRegTformtriEsti_SF_V1(imgA,imgB,XY_0,XY_1)
% estimation of ImRegTformtri
%   imgA fixed image
%   imgB moving image
%   XY_0 fixed feature points
%   XY_1 moving feature points

% initial trimesh
Dim=size(imgB,1);   % image dimension
Dim_e=round(Dim/6); % image dimension expansion
Dim_ETR=[-Dim_e round(Dim/2) Dim+Dim_e];
Dim_E=Dim_ETR(end)-Dim_ETR(1);
imgBE=uint8(ones(Dim_E))*min(imgB(:));
imgBE(Dim_e:Dim_e+Dim-1,Dim_e:Dim_e+Dim-1)=imgB;

[TRx,TRy]=meshgrid(Dim_ETR,Dim_ETR); % expansion
TRx(2:end-1,2:end-1)=nan;
TRy(2:end-1,2:end-1)=nan;
TRx=reshape(TRx,[],1);
TRy=reshape(TRy,[],1);
TRx(isnan(TRx))=[];
TRy(isnan(TRy))=[];
XY_0=[XY_0; [TRx TRy]];
XY_1=[XY_1; [TRx TRy]];
XY_0=XY_0+Dim_e;
XY_1=XY_1+Dim_e;
tri_0 = delaunayTriangulation(XY_0);  
tri_1=tri_0;
tri_1.Points=XY_1;

% figure; hold on; axis equal; axis off
% imagesc(imgAE)
% rectangle('Position',[Dim_e Dim_e Dim Dim],'EdgeColor','k')
% triplot(tri_0,'Color',[0.6 0.6 0.6])
% triplot(tri_1,'Color','r')
% set(gca,'YDir','reverse')

% ----------------------------------------------------------
% imreg estimation
tform_T=cell(size(tri_1,1),1);       % tform for each patch
tri_0_base=tri_0.ConnectivityList;   % each patch
imgBE_patch_mask=[];                       % total patch of imgB | *X*Xpatch_N
for ci=1  : size(tri_1)
    Point_0=XY_0(tri_0_base(ci,:),:);
    Point_1=XY_1(tri_0_base(ci,:),:);

    % tform
    [tform,~, ~] = estimateGeometricTransform( ...
        Point_1,Point_0,'affine'); % moving vs fixed | affine
    tform_T{ci,1}=tform;
    
    Point_1poly=[Point_1; Point_1(1,:)];
    bw_1=poly2mask(Point_1poly(:,1),Point_1poly(:,2),Dim_E,Dim_E);
    imgBE_patch_mask(:,:,ci)=bw_1;
end
imgBE_patch_mask=uint8(imgBE_patch_mask);

% imreg implementation
imgBE_patchReg_T=uint8([]);
for ci=1:length(tform_T)  % input >> imgB(E) | imgBE_patch_mask | tform_T | (Dim, Dim_e)
    imgBE_patch=imgBE.*imgBE_patch_mask(:,:,ci);
    imgBE_patchReg = imwarp(imgBE_patch, tform_T{ci,1},...
        'OutputView', imref2d(size(imgBE_patch)));
    imgBE_patchReg_T(:,:,ci)=imgBE_patchReg;
end
imgBEReg=sum(imgBE_patchReg_T,3);
imgBReg=imgBEReg(Dim_e:Dim_e+Dim-1,Dim_e:Dim_e+Dim-1);
imgBReg=uint8(imgBReg);

% output
RegtriEsti.imgA=imgA;
RegtriEsti.imgB=imgB;
RegtriEsti.Dim=Dim;
RegtriEsti.Dim_e=Dim_e;
RegtriEsti.imgBE_patch_mask=imgBE_patch_mask;
RegtriEsti.tform_T=tform_T;
end


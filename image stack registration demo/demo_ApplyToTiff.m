clc
clear

% 3#-0d data of 3# mouse in day 0
% 3#-10d data of 3# mouse in day 10

%%
TarFolder='3#-10d';

% load ImregTriangle -> RegtriEsti
load(fullfile(pwd,[TarFolder '_RegtriEsti.mat']))
RegtriEsti=ImregTriangle.ImRegister.tform;
tform_T=RegtriEsti.tform_T;
imgBE_patch_mask=RegtriEsti.imgBE_patch_mask;

% apply to TIFF stack
namefile_pre='Substack (1-100)';
pathrawtif=fullfile(pwd,TarFolder,[namefile_pre '.tif']);
if ~exist(pathrawtif,'file')
    disp('----Error: No target file----')
else
    pathrawreg=fullfile(pwd,TarFolder,[namefile_pre '_Reg.tif']);
    if exist(pathrawreg,'file')
        delete(pathrawreg)
    end
    TifInfo=imfinfo(pathrawtif);
    Slice=size(TifInfo,1);
    tic
    for ti=1 : Slice  % for each frame
%         tic
        % imgB
        imgB=imread(pathrawtif, ti);
        Dim=size(imgB,1);   % image dimension
        Dim_e=round(Dim/6); % image dimension expansion
        Dim_ETR=[-Dim_e round(Dim/2) Dim+Dim_e];
        Dim_E=Dim_ETR(end)-Dim_ETR(1);
        imgBE=uint8(ones(Dim_E))*min(imgB(:));
        imgBE(Dim_e:Dim_e+Dim-1,Dim_e:Dim_e+Dim-1)=imgB;
        
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
        
        disp([ TarFolder ' | ' num2str(ti,'%03d')...
            ' | ' num2str(Slice)  ' | '  num2str(toc) ' s'])
        imwrite(imgBReg,pathrawreg,'WriteMode','append')
    end
end

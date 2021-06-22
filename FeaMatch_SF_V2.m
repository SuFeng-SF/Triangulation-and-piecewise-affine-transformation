function [FeaA_xy_round,FeaA_xy_match,score] = FeaMatch_SF_V2(FeaA_xy,imgA,imgB,Dim_eT,FFT_threT)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明

% Dim_e=32; % image dimension expansion
% FFT_thre=1; % FFT threshold for feature match

Dim_e=Dim_eT(1);

Dim=size(imgB,1);   % image dimension
Dim_E=Dim+Dim_e*2;
imgAE=uint8(ones(Dim_E))*min(imgA(:));
imgAE(Dim_e:Dim_e+Dim-1,Dim_e:Dim_e+Dim-1)=imgA;
imgBE=uint8(ones(Dim_E))*min(imgB(:));
imgBE(Dim_e:Dim_e+Dim-1,Dim_e:Dim_e+Dim-1)=imgB;

FeaAE_xy=round(FeaA_xy+Dim_e);

TR_ind=-Dim_e:Dim_e;
TR_ind_2=(Dim_eT(1)-Dim_eT(2)):(Dim_eT(1)-Dim_eT(2))+Dim_eT(2)*2;
FeaAE_xy_trans=[];
R_T=[];
LocaScore_T=[];
for ci=1:size(FeaAE_xy,1)
%     disp([ci size(FeaAE_xy,1)])
    I1 = imgAE(TR_ind+FeaAE_xy(ci,2),TR_ind+FeaAE_xy(ci,1));  % ref
    I2 = imgBE(TR_ind+FeaAE_xy(ci,2),TR_ind+FeaAE_xy(ci,1));  % floating
    [I1_trans,I2_trans,imtrans,R] = FFT_Trans_SF_V1(I1,I2);
    
    I1_trans_1=I1_trans(TR_ind_2,TR_ind_2);
    I1_trans_2=I2_trans(TR_ind_2,TR_ind_2);
    [~,~,imtrans_1,R_1] = FFT_Trans_SF_V1(I1_trans_1,I1_trans_2);
    
    regmax = imregionalmax(R);
    LocaScore=R(regmax);
    LocaScore=sort(LocaScore,'descend');
    LocaScore=[LocaScore; zeros(2,1)];
    TR1=LocaScore(1)-LocaScore(2);
    
    regmax = imregionalmax(R_1);
    LocaScore=R(regmax);
    LocaScore=sort(LocaScore,'descend');
    LocaScore=[LocaScore; zeros(2,1)];
    TR2=LocaScore(1)-LocaScore(2);
    
    LocaScore_T=[LocaScore_T; TR1 TR2];  % FFT 32 24
    FeaAE_xy_trans=[FeaAE_xy_trans; imtrans imtrans_1];  % 
    
%     LocaMax(1)-LocaMax(2)
%     figure(1)
%     imshowpair(imresize(I1,2),imresize(I2_trans,2),'montage')
end
% FeaAE_xy_match=FeaAE_xy-FeaAE_xy_trans(:,1:2); % 一步矫正
FeaAE_xy_match=FeaAE_xy-FeaAE_xy_trans(:,1:2)+FeaAE_xy_trans(:,3:4); % 2步矫正

Score_ind_1=LocaScore_T(:,1)>FFT_threT(1);
Score_ind_2=LocaScore_T(:,2)>FFT_threT(2);
Score_ind=Score_ind_1.*Score_ind_2;
Score_ind=Score_ind==1;
LocaScore_T=LocaScore_T(Score_ind,:);
FeaAE_xy_trans=FeaAE_xy_trans(Score_ind,:);
FeaAE_xy_round=FeaAE_xy(Score_ind,:);
FeaAE_xy_match=FeaAE_xy_match(Score_ind,:);

FeaA_xy_round=FeaAE_xy_round-Dim_e;
FeaA_xy_match=FeaAE_xy_match-Dim_e;
score=LocaScore_T(:,1);
end


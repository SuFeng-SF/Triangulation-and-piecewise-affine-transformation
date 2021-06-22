function [featuresOut] = FeatureIntraDistM_SF_V3(featuresIn)
%UNTITLED3 此处显示有关此函数的摘要
%   计算特征的相似性
%   detectMSERFeatures | region feature
%   Location | Axes | Orientation | Pixelist


IoUM=zeros(featuresIn.Count);   % eye
% LocaM=pdist(featuresIn.Location);
% LocaM=squareform(LocaM);
Area_T=zeros(featuresIn.Count,1);
for ci=1:featuresIn.Count
    Area_T(ci,1)=size(featuresIn.PixelList{ci,1},1);
end
for ci=1:featuresIn.Count-1
    for cj=ci+1:featuresIn.Count
        TR1=featuresIn.PixelList{ci,1};
        TR2=featuresIn.PixelList{cj,1};
        TR3=cat(1,TR1,TR2);
        TR3=unique(TR3,'rows');
        IoU=(size(TR1,1)+size(TR2,1)-size(TR3,1))/size(TR3,1);
        IoUM(ci,cj)=IoU;
        IoUM(cj,ci)=IoU;
    end
end
% IoU thre | 保留 area 较大的特征区域
IoUThre=0.2;
TR_ind=1:featuresIn.Count;  % 索引
Area_T_ind=Area_T;
while max(IoUM(:))>=IoUThre
    [sa,sb]=find(IoUM==max(IoUM(:)));   % max vs min
    TR1=find(IoUM(sa(1),:)>=IoUThre);
    TR2=find(IoUM(:,sb(1))>=IoUThre);
    TR3=unique([TR1'; TR2]);      % 聚类索引
    [~,sc]=max(Area_T_ind(TR3));  % 保留面积最大的
    TR3(sc)=[];
    TR_ind(TR3)=[];
    Area_T_ind(TR3)=[];
    IoUM(:,TR3)=[];
    IoUM(TR3,:)=[];
end

featuresOut=featuresIn(TR_ind);

% figure; hold on
% imshow(imgA)
% plot(featuresOut)

% % dendrogram(Z,0)
% max(T)
% figure
% for ci=1 : max(T)
%     clf
%     imagesc(imgA); 
%     hold on
%     TR1=find(T==ci);
%     length(TR1)
%     plot(featuresIn(TR1));
%     pause(0.5)
% end


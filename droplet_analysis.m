%% Initialize workspace and specify input parameters
% initialzed workspace
clearvars;      close all;

% specify input directory and file name
idr=['/Users/swkim/Desktop/Research/droplet_analysis/experimental_data/',...
    'image2_stack/'];
tmx=17;
zmx=59;

pic=cell(tmx,1);
%% Generate maximum intensity projection image
tic
for tmc=1:tmx
    picStk=cell(zmx,1);
    for stc=1:zmx
        picStk{stc}=imread(sprintf('%sImage 2_t%03d_z%03d_c001.tif',...
            idr,tmc,stc));
    end
    pic{tmc}=drp_maxIntensityProjection(picStk);
end
toc


%% Gray to binary image with threshold
picBn=cell(tmx,1);
thCri=0.25;
smObj=100;

for tmc=1:tmx
    picBn{tmc}=imbinarize(pic{tmc},thCri);
    picBn{tmc}=bwareaopen(picBn{tmc},smObj);
    picBn{tmc}=imerode(picBn{tmc},strel('disk',5));
    picBn{tmc}=bwareaopen(picBn{tmc},smObj);
    picBn{tmc}=imdilate(picBn{tmc},strel('disk',5));        
end

%% Label individual images
bndLayer=10;
picLb=drp_cellLabel(picBn,bndLayer,tmx);

%% Generate images that show cell ID
picLbCmb=cell(tmx,1);
for tmc=1:tmx
    picLbCmb{tmc}=drp_showCellId(pic{tmc},picBn{tmc},picLb{tmc},30);
end

% imshow(picLbCmb{1});
    
% vd=VideoWriter('cellId.mp4','MPEG-4');
% vd.FrameRate=2;
% 
% open(vd);
% 
% for dtc=1:tmx
%     writeVideo(vd,picLbCmb{dtc});
% end
% 
% close(vd);  

arDt=cell(tmx,1);

for tmc=1:tmx
    cellId=unique(picLb{tmc}(:));
    cellId=cellId(cellId~=0);
    arDt{tmc}=zeros(size(cellId,1),3);
    for clc=1:size(cellId,1)
        arDt{tmc}(clc,:)=[tmc,cellId(clc)-10^6,...
            sum(picLb{tmc}(:)==cellId(clc))];
    end
end

arDt=cell2mat(arDt);

save('image2_areaData.mat','arDt');
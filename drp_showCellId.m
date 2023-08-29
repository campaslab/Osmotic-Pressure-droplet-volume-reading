%% combine experimental image and segmented image with cell id label

function picComb=drp_showCellId(picOrg,picBn,picLb,fontSz)

picSz=size(picOrg);
picComb=uint8(zeros([picSz,3]));
picComb(:,:,2)=picOrg;
picComb(:,:,1)=picBn*255;

hh=figure;
set(hh,'visible','off');
imshow(picComb);
set(gcf, 'Position', get(0, 'Screensize'));
hold on;

cellId=unique(picLb(:));
cellId=cellId(cellId~=0);

for cec=1:size(cellId,1)
    [xx,yy]=find(picLb==cellId(cec));
    cen=[mean(xx),mean(yy)];
    if cellId(cec)>0
        text(cen(2),cen(1),num2str(cellId(cec)-10^6),'FontSize',...
            fontSz,'Color','Blue','HorizontalAlignment', 'center');
    else
        text(cen(2),cen(1),num2str(cellId(cec)),'FontSize',...
            fontSz,'Color','Blue','HorizontalAlignment', 'center');
    end
end

picComb=getframe(gca);
picComb=picComb.cdata;

close all;

end
%% Locally adjust intensity
% winSz: local window size
% stSz: window displacement step size

function picAdj=drp_adjustContrast(pic,winSz,stSz)

picAdj=pic;
picSz=size(picAdj);
minSig=0.2;


xpos=1;
while xpos+winSz<picSz(1)
    ypos=1;
    while ypos+winSz<picSz(2)        
        picPt=imadjust(pic(xpos:xpos+winSz-1,ypos:ypos+winSz-1));
        picAdjPt=picAdj(xpos:xpos+winSz-1,ypos:ypos+winSz-1);
        if sum(picPt(:)>minSig*255)/numel(picPt)>0.1
            [xx,yy]=find(picPt>picAdjPt);
            idx=sub2ind([winSz,winSz],xx,yy);
            picAdjPt(idx)=picPt(idx);
            picAdj(xpos:xpos+winSz-1,ypos:ypos+winSz-1)=picAdjPt;        
           
        end
        ypos=ypos+stSz;
    end
    
    picPt=imadjust(pic(xpos:xpos+winSz-1,ypos:end));
    picAdjPt=picAdj(xpos:xpos+winSz-1,ypos:end);
    if sum(picPt(:)>minSig*255)/numel(picPt)>0.1
        [xx,yy]=find(picPt>picAdjPt);
        idx=sub2ind([winSz,picSz(2)-ypos+1],xx,yy);
        picAdjPt(idx)=picPt(idx);
        picAdj(xpos:xpos+winSz-1,ypos:end)=picAdjPt;        
    end

    xpos=xpos+stSz;
end

picPt=imadjust(pic(xpos:end,ypos:end));
picAdjPt=picAdj(xpos:end,ypos:end);

if sum(picPt(:)>minSig*255)/numel(picPt)>0.1
    [xx,yy]=find(picPt>picAdjPt);
    idx=sub2ind([picSz(1)-xpos+1,picSz(2)-ypos+1],xx,yy);
    picAdjPt(idx)=picPt(idx);
    picAdj(xpos:end,ypos:end)=picAdjPt;       
end
    
end
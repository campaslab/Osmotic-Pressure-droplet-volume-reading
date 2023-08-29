%% Label cells with tracking 

function picLb=drp_cellLabel(picBn,bndLayer,tmx)

picLb=cell(tmx,1);

picLb{1}=bwlabel(picBn{1});
bndCell=union(unique([picLb{1}(1:bndLayer,:);...
    picLb{1}(end-bndLayer+1:end,:)]),...
    unique([picLb{1}(:,1:bndLayer),picLb{1}(:,end-bndLayer+1:end)]));
bndCell=bndCell(bndCell~=0);

intCell=unique(picLb{1}(:));
intCell=intCell(intCell~=0);
intCell=setdiff(intCell,bndCell);

newId=(1:size(intCell,1)).'+10^6;

for clc=1:size(bndCell,1)
    picLb{1}(picLb{1}==bndCell(clc))=0;
end

oldLoc=zeros(size(intCell,1),2);
for clc=1:size(intCell,1)
    picLb{1}(picLb{1}==intCell(clc))=newId(clc);
    [xx,yy]=find(picLb{1}==newId(clc));
    oldLoc(clc,:)=[mean(xx),mean(yy)];
end
oldId=newId;

for tmc=2:tmx
    picLbOrg=bwlabel(picBn{tmc});
    picLb{tmc}=picLbOrg;
    bndCell=union(unique([picLb{tmc}(1:bndLayer,:);...
        picLb{tmc}(end-bndLayer+1:end,:)]),...
        unique([picLb{tmc}(:,1:bndLayer),picLb{tmc}(:,end-bndLayer+1:end)]));
    bndCell=bndCell(bndCell~=0);
    
    for clc=1:size(bndCell,1)
        picLb{tmc}(picLb{tmc}==bndCell(clc))=0;
    end


    intCell=unique(picLb{tmc}(:));
    intCell=intCell(intCell~=0);
    intCell=setdiff(intCell,bndCell);
    
    % assign new id based on Eucleadian distance metric
    newId=zeros(size(intCell,1),1);
    newLoc=zeros(size(intCell,1),2);
    
    
    if isempty(oldId)
        newIdAdd=10^6;
        for clc=1:size(intCell,1)
            [xx,yy]=find(picLb{tmc}==intCell(clc));
            newLoc(clc,:)=[mean(xx),mean(yy)];
            newId(clc)=newIdAdd;
            newIdAdd=newIdAdd+1;
        end
    else
        newIdAdd=max(oldId)+1;
    
        for clc=1:size(intCell,1)
            [xx,yy]=find(picLb{tmc}==intCell(clc));
            newLoc(clc,:)=[mean(xx),mean(yy)];
            dis=sum((oldLoc-repmat(newLoc(clc,:),size(oldLoc,1),1)).^2,2);
            [~,idx]=sort(dis);
            newId(clc)=oldId(idx(1));
            idx=sub2ind(size(picBn{tmc}),xx,yy);
            picLb{tmc}(idx)=newId(clc);
        end
    end    
    % check whether their is doulbe count for new cell id
    newIdUnq=unique(newId);
    
    if size(newId,1)~=size(newIdUnq,1)
       newIdCnt=zeros(size(newIdUnq,1),1);
       for clc=1:size(newIdUnq,1)
           newIdCnt(clc)=sum(newId==newIdUnq(clc));
       end
       mltId=newIdUnq(newIdCnt>1);
       
       for clc=1:size(mltId,1)
           chkId=find(newId==mltId(clc));
           oldLocChk=oldLoc(oldId==mltId(clc),:);
           newLocChk=newLoc(newId==mltId(clc),:);
           dis=sqrt(sum((newLocChk-repmat(oldLocChk,size(newLocChk,1),1)).^2,2));
           [~,idxx]=sort(dis);
           for idc=2:size(chkId,1)
               newId(chkId(idxx(idc)))=newIdAdd;
               [xx,yy]=find(picLbOrg==intCell(chkId(idxx(idc))));
               idx=sub2ind(size(picLb{tmc}),xx,yy);
               picLb{tmc}(idx)=newIdAdd;
               newIdAdd=newIdAdd+1;
           end
       end
    end
    
    oldId=newId;
    oldLoc=newLoc;
end
       
end
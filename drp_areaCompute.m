%% Compute area values
% area array structure is [time,cell id,area]

function area=drp_areaCompute(picLb,tmx)

area=cell(tmx,1);

for tmc=1:tmx
    picLbInd=picLb{tmc};
    idAll=unique(picLbInd(:));
    idAll=idAll(idAll~=0);
    
    imx=numel(idAll);
    area{tmc}=zeros(imx,3);
    
    for idc=1:imx
        arInd=(picLbInd==idAll(idc));
        arInd=sum(arInd(:));
        area{tmc}(idc,:)=[tmc,idAll(idc)-10^6,arInd];
    end
end

area=cell2mat(area);

end
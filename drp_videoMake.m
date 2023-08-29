%% Create a video

function drp_videoMake(pic,fmRate,tmx,csNm,vdNm)

vd=VideoWriter(sprintf('%s_%s.mp4',csNm,vdNm),'MPEG-4');
% vd=VideoWriter(sprintf('%s_%s.avi',csNm,vdNm),'Motion JPEG Avi');
vd.FrameRate=fmRate;

open(vd);

for tmc=1:tmx
    writeVideo(vd,pic{tmc});
end

close(vd);


end
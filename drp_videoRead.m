%% Read frames as gray scale from a movie

function [pic,fmRate,tmx]=drp_videoRead(idr,csNm)

mov=VideoReader(sprintf('%s%s.avi',idr,csNm));
fmRate=mov.FrameRate;
tmx=mov.Duration*mov.FrameRate;

pic=cell(tmx,1);
for tmc=1:tmx
    pic{tmc}=imadjust(rgb2gray(readFrame(mov)));
end

end
%Produce your images programmatically, rather than by exporting a figure, if you can, 
%as it will be much faster. SC (on the FEX) is good for this. Editing Joseph Cheng's code, you would do the following:

% First, down;oad the SC function for powerful image rendering from link:
% https://www.mathworks.com/matlabcentral/fileexchange/16233-sc-powerful-image-rendering
addpath('S:\pool\sc');
%suppose you have 
timePts=[1:256];
[y, x] = ndgrid(1:256);
 vidfile = VideoWriter('testmovie.mp4','MPEG-4');
 open(vidfile);
 
 for tp = 1:length(timePts)
    z = sin(x*2*pi/tp)+cos(y*2*pi/tp);
    im = sc(z, 'hot');
    writeVideo(vidfile, im);
 end
 
close(vidfile)
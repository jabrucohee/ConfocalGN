% Example of mock confocal data generation
%   We first generate a baseball seam curve
%   We then make it confocal

%% Parameters
% Degree of coiling of the base ball seam curve
b=0.02;
% Orientation of the BBseam curve
angs=[pi/6 pi/6 0];
% Radius of the sphere containing BB seam curve
R=90;
% Resolution 
dt=0.001;
% Size of the "perfect" image
Npts=300;
% Properties of the microscope
psf=[8 8 32];
pix=[6 6 24];
% Properties of the fluorophores
%   gaussian fluorescence is assumed for all points in the original signal
%   This is VERY tough to estimate theoretically as it depends on the
%   number of fluorophores, exposure time, etc.
mean_fluo=1.0;
stdev_fluo=0.5;
% Background fluorescence
mean_bg=0;
stdev_bg=0.02;
% pixel noise from camera
mean_px=0;
stdev_px=0.003;

%% Generating a set of points ; here, a BBseam curve
RR=generate_bbseam(Npts,b,R,dt,angs);

%% Generating an image from these points
% Image includes fluorophore stochasticity and background fluorescence
[img,pts]=generate_pts_img(Npts,RR,mean_fluo,stdev_fluo,mean_bg,stdev_bg);

%% Generating the stack from the image
% Includes pixel noise
[stacks,offset]=generate_stacks(img,psf,pix,mean_px,stdev_px);

%% Image segmentation to compare
im=threshold(stacks);
[ Pts,W ] = convertpoints( im , pix );
Pts(1:2,:)=Pts(1:2,:)-offset(1:2)'*ones(1,size(Pts,2))/2;
Pts(3,:)=Pts(3,:)-offset(3);

%% Plotting 
if 1
    figure
    hold all
    scatter3(Pts(1,:)/pix(1),Pts(2,:)/pix(1),Pts(3,:)/pix(1))
    scatter3(pts(1,:)/pix(1),pts(2,:)/pix(1),pts(3,:)/pix(1),'k.')
end
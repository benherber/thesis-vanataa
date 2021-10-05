% ------------------------ %
% Plot Array Response      %
% Name   : plots.m         %
% Author : Benjamin Herber %
% Date   : Fall 2021       %
% ------------------------ %
clear
clc

vanatta;

%% Plot theta dependence

fig = figure;
P = 0;

array_factor = zeros(1,360);
angles = zeros(1,360);
i = sqrt(-1);
theta_imps = [0, pi/4, pi/3, pi/2, 2*pi/3, 3*pi/4, pi];
num_steps = 7;

for idx = 1:num_steps
    theta_imp = theta_imps(idx);
    for theta_obs = 1:360
        angles(theta_obs) = deg2rad(theta_obs);
        array_factor(theta_obs) = feval(find_reflectedE, 1, DEFAULT_NUM_ELEMENTS,...
            DEFAULT_WAVELEN, DEFAULT_SPACING, theta_imp, deg2rad(theta_obs));
        array_factor(theta_obs) = abs(array_factor(theta_obs));
    end
    
    polarplot(angles, array_factor);

    pp = gca;
    title("Array Factor for \theta_i: " + rad2deg(theta_imp) + "°")
    pp.FontSize = 14;
    pp.ThetaAxisUnits = 'radians';
    thetaticks([0, pi/4, pi/3, pi/2, 2*pi/3, 3*pi/4, pi, 5*pi/4, 4*pi/3, 3*pi/2, 5*pi/3, 7*pi/4, 2*pi])
    drawnow

    frame = getframe(fig);
    im{idx} = frame2im(frame);
end
close;

%% Write Gif
filename = "ThetaDependence.gif";
for idx = 1:num_steps
    [A,map] = rgb2ind(im{idx},256);
    if idx == 1
        imwrite(A,map,filename,"gif","LoopCount",Inf,"DelayTime",1);
    else
        imwrite(A,map,filename,"gif","WriteMode","append","DelayTime",1);
    end
end

%% Test Spacing Difference

clear
clc

vanatta;

fig = figure;
P = 0;

array_factor = zeros(1,360);
angles = zeros(1,360);
i = sqrt(-1);
testwavelen = DEFAULT_WAVELEN;
spacings = 0:(testwavelen/16.0):(2.0*testwavelen);
num_steps = length(spacings);

for idx = 1:num_steps
    spacing = spacings(idx);
    for theta_obs = 1:360
        angles(theta_obs) = deg2rad(theta_obs);
        array_factor(theta_obs) = feval(find_reflectedE, 1, DEFAULT_NUM_ELEMENTS,...
            testwavelen, spacing, pi/2, deg2rad(theta_obs));
        array_factor(theta_obs) = abs(array_factor(theta_obs));
    end
    
    polarplot(angles, array_factor);

    pp = gca;
    title("Array Factor (\theta_i=90°) for Spacing: " + ((spacing) / testwavelen) + "\lambda")
    pp.FontSize = 14;
    pp.ThetaAxisUnits = 'radians';
    thetaticks([0, pi/4, pi/3, pi/2, 2*pi/3, 3*pi/4, pi, 5*pi/4, 4*pi/3, 3*pi/2, 5*pi/3, 7*pi/4, 2*pi])
    drawnow

    frame = getframe(fig);
    im{idx} = frame2im(frame);
end
close;

%% Write Gif
filename = "SpacingDependence.gif";
for idx = 1:num_steps
    [A,map] = rgb2ind(im{idx},256);
    if idx == 1
        imwrite(A,map,filename,"gif","LoopCount",Inf,"DelayTime",0.25);
    else
        imwrite(A,map,filename,"gif","WriteMode","append","DelayTime",0.25);
    end
end

%% Test Number of Elements Dependency

%% Test Spacing Difference

clear
clc

vanatta;

fig = figure;
P = 0;

array_factor = zeros(1,360);
angles = zeros(1,360);
i = sqrt(-1);
elements = 0:2:32;
num_steps = length(elements);

for idx = 1:num_steps
    num_ele = elements(idx);
    for theta_obs = 1:360
        angles(theta_obs) = deg2rad(theta_obs);
        array_factor(theta_obs) = feval(find_reflectedE, 1, num_ele,...
            DEFAULT_WAVELEN, DEFAULT_SPACING, pi/2, deg2rad(theta_obs));
        array_factor(theta_obs) = abs(array_factor(theta_obs));
    end
    
    polarplot(angles, array_factor);

    pp = gca;
    title("Array Factor (\theta_i=90°), (spacing=\lambda/2) for " + num_ele + "Elements")
    pp.FontSize = 14;
    pp.ThetaAxisUnits = 'radians';
    thetaticks([0, pi/4, pi/3, pi/2, 2*pi/3, 3*pi/4, pi, 5*pi/4, 4*pi/3, 3*pi/2, 5*pi/3, 7*pi/4, 2*pi])
    drawnow

    frame = getframe(fig);
    im{idx} = frame2im(frame);
end
close;

%% Write Gif
filename = "NumberElementDependence.gif";
for idx = 1:num_steps
    [A,map] = rgb2ind(im{idx},256);
    if idx == 1
        imwrite(A,map,filename,"gif","LoopCount",Inf,"DelayTime",0.25);
    else
        imwrite(A,map,filename,"gif","WriteMode","append","DelayTime",0.25);
    end
end
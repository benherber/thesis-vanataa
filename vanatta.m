% ------------------------ %
% Van Atta Model Script    %
% Name   : vanatta.m       %
% Author : Benjamin Herber %
% Date   : Fall 2021       %
% ------------------------ %
clear
clc
%% Constants
LIGHTSPEED = physconst('Lightspeed');

DEFAULT_THETA_IMPINGING = pi/2;
DEFAULT_NUM_ELEMENTS = 8;
DEFAULT_WAVELEN = LIGHTSPEED/2.4E9;
DEFAULT_SPACING = DEFAULT_WAVELEN/2.0;
DEFAULT_PHASES = zeros(DEFAULT_NUM_ELEMENTS,1);
find_reflectedE = @priv_reflected_E;

%% Find phase change 

function phase = find_phase(theta, wavelen, spacing, n)
    phase = ((2.0*pi)/wavelen)*spacing*n*cos(theta);
end

%% Find reflection

function resE = priv_reflected_E(incoming_E, num_elements, wavelen, spacing, theta_impinging, theta_obs)
    tmp = 0;
    for idx = 1:num_elements
        tmp = tmp + exp(1i*(find_phase(theta_obs, wavelen, spacing, (idx-1))-find_phase(theta_impinging, wavelen, spacing, (idx-1))));
    end

    resE = incoming_E*tmp;
end



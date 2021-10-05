% ------------------------ %
% Van Atta Model Script    %
% Name   : vanatta.m       %
% Author : Benjamin Herber %
% Date   : Fall 2021       %
% ------------------------ %
%% Constants
LIGHTSPEED = physconst('Lightspeed');

DEFAULT_THETA_IMPINGING = pi/4;
DEFAULT_NUM_ELEMENTS = 8;
DEFAULT_WAVELEN = LIGHTSPEED/2.4E9;
DEFAULT_SPACING = DEFAULT_WAVELEN/2.0;
find_phases = @priv_find_phases;

res = find_phases(DEFAULT_THETA_IMPINGING, DEFAULT_NUM_ELEMENTS, DEFAULT_WAVELEN, DEFAULT_SPACING, 10);

%% Find phase change vector

function phases = priv_find_phases(theta_impinging, num_elements, wavelen, spacing)
    tmp = zeros(num_elements,1);
    for idx = 1:num_elements
        tmp(idx) = ((-2.0*pi)/wavelen)*(idx-1)*spacing*cos(theta_impinging);
    end

    phases = tmp;
end



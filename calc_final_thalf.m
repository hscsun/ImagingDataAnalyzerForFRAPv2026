%% 10. Local Functions
function [final_val, thalf_val] = calc_final_thalf(yout, FE21, fmodel, gx)
% Calculate final recovery level and half recovery time from fit object
% Inputs:
%   yout   - fit object from curve fitting
%   FE21   - fitted curve values at smooth x points
%   fmodel - fitting model identifier (1, 2, or 3)
%   gx     - smooth x vector for interpolation
% Outputs:
%   final_val - final recovery level
%   thalf_val - half recovery time

switch fmodel
    case 1  % Model 1: va - a*exp(-b*x)
        final_val = roundn(yout.a / (1 - yout.va + yout.a), -2);
        thalf_val = roundn(0.6931 / yout.b, -2);
    case 3  % Model 3: a - a*exp(-b*x)
        final_val = roundn(yout.a, -2);
        thalf_val = roundn(0.6931 / yout.b, -2);
    case 2  % Model 2: va - a*exp(-b*x) - c*exp(-d*x)
        hm = (yout.va + FE21(1)) / 2;
        yy_idx = find(FE21 < hm);
        ind = yy_idx(end);
        final_val = roundn((yout.a + yout.c) / (1 - yout.va + yout.a + yout.c), -2);
        thalf_val = roundn(gx(ind), -2);
end
end
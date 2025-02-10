%%
cam = readmatrix("SonyDXC930_spectra.txt");
ls_d65 = readmatrix("CIEStdIlluminantD65.txt");
patch = readmatrix("MacbethPatch17.txt");
cam_red_interp = interp1(cam(:,1), cam(:,2), ls_d65(:,1), "spline");
cam_green_interp = interp1(cam(:,1), cam(:,3), ls_d65(:,1), "spline");
cam_blue_interp = interp1(cam(:,1), cam(:,4), ls_d65(:,1), "spline");
%%
num_red = ls_d65(:,2).*patch(:,2).*cam_red_interp(:);
sum_num_red = sum(num_red);
denom_red = ls_d65(:,2).*cam_red_interp(:);
sum_denom_red = sum(denom_red);
signal_red = (sum_num_red/sum_denom_red)*255;
%%
num_green = ls_d65(:,2).*patch(:,2).*cam_green_interp(:);
sum_num_green = sum(num_green);
denom_green = ls_d65(:,2).*cam_green_interp(:);
sum_denom_green = sum(denom_green);
signal_green = (sum_num_green/sum_denom_green)*255;
%%
num_blue = ls_d65(:,2).*patch(:,2).*cam_blue_interp(:);
sum_num_blue = sum(num_blue);
denom_blue = ls_d65(:,2).*cam_blue_interp(:);
sum_denom_blue = sum(denom_blue);
signal_blue = (sum_num_blue/sum_denom_blue)*255;

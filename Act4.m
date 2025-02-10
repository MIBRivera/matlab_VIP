%% Load necessary files: Munsell Spectra, Illuminant, Camera spectra, Reflectance
% It's necessary to run Act2.m before loading this notebook.
load("munsell400_700_5.mat");
ls_d65 = readmatrix("CIEStdIlluminantD65.txt");
%Object reflectances
patch6 = readmatrix("MacbethPatch6.txt");
patch8 = readmatrix('MacbethPatch8.txt'); 
patch17 = readmatrix('MacbethPatch17.txt');
%% Use `pca` function
C = ls_d65(:,2).*munsell(:,:);
[COEFF, SCORE, LATENT, TSQUARED, EXPLAINED, MU] = pca(C', 'Centered',false);
CSEXPL = cumsum(EXPLAINED);
figure(1); plot(COEFF(:,1:5))
legend('1st eigenspectra','2nd eigenspectra','3rd eigenspectra','4th eigenspectra','5th eigenspectra')
xlabel('Coefficent')
ylabel('Coefficient Values')
title('Weight of each coefficient for first 5 principal components')

%% Solving for eigenspectra coefficients
% Load Act2.m first to get sum_nums and interps!
P_new = [cam_red_interp, cam_green_interp, cam_blue_interp];
T = P_new'*COEFF(:,1:3);
q_6 = [98.4993, 305.9331, 588.8412]; %Macbeth patch 6 rgb values (w/o white balance). NOTE: q' here = q in the text!
a_6 = (T'*T)\(T'*q_6');
q_8 = [29.1757, 75.9701, 512.9116]; %Macbeth patch 6 rgb values (w/o white balance). NOTE: q' here = q in the text!
a_8 = (T'*T)\(T'*q_8');
q_17 = [101.5922, 70.3524, 434.4236]; %Macbeth patch 6 rgb values (w/o white balance). NOTE: q' here = q in the text!
a_17 = (T'*T)\(T'*q_17');
%%
%Getting the color signal from pca (patch 6)
C_pca_6 = zeros(61,3);
C_pca_6(:,1) = a_6(1).*COEFF(:,1);
C_pca_6(:,2) = a_6(2).*COEFF(:,2);
C_pca_6(:,3) = a_6(3).*COEFF(:,3);
C_pca_final_6 = zeros(61,1);
for i = 1:1:61
    C_pca_final_6(i,:) = sum(C_pca_6(i,:));
end

%Getting the color signal from pca (patch 8)
C_pca_8 = zeros(61,3);
C_pca_8(:,1) = a_8(1).*COEFF(:,1);
C_pca_8(:,2) = a_8(2).*COEFF(:,2);
C_pca_8(:,3) = a_8(3).*COEFF(:,3);
C_pca_final_8 = zeros(61,1);
for i = 1:1:61
    C_pca_final_8(i,:) = sum(C_pca_8(i,:));
end

%Getting the color signal from pca (patch 17)
C_pca_17 = zeros(61,3);
C_pca_17(:,1) = a_17(1).*COEFF(:,1);
C_pca_17(:,2) = a_17(2).*COEFF(:,2);
C_pca_17(:,3) = a_17(3).*COEFF(:,3);
C_pca_final_17 = zeros(61,1);
for i = 1:1:61
    C_pca_final_17(i,:) = sum(C_pca_17(i,:));
end

%%
%Comparing color signal from pca and theoretical color signal of patches
C_6 = ls_d65(:,2).*patch6(:,2); %color signal of Macbeth patch 6
C_8 = ls_d65(:,2).*patch8(:,2); %color signal of Macbeth patch 17
C_17 = ls_d65(:,2).*patch17(:,2); %color signal of Macbeth patch 17
figure(2); plot(ls_d65(:,1),C_pca_final_6,'k');
hold on; plot(ls_d65(:,1),C_6,'b');
hold on; plot(ls_d65(:,1),C_pca_final_8,'ko');
hold on; plot(ls_d65(:,1),C_8,'bo');
hold on; plot(ls_d65(:,1),C_pca_final_17,'k*');
hold on; plot(ls_d65(:,1),C_17,'b*');
legend('C_{6, PCA}','C_6','C_{8, PCA}','C_8','C_{17, PCA}','C_{17}')
xlabel('Wavelength (nm)')
ylabel('Color Signal C(\lambda)')
title('Color spectra for Macbeth Patches')
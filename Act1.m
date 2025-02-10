%%
%Read Image
 [file, path] = uigetfile('.jpg');
 filename =[path,file];
 I = imread(filename);
 R = I(:,:,1); G = I(:,:,2); B = I(:,:,3);
 figure(1);imshow(I);
%%
%Crop region of interest and note the range
J = imcrop(I);
figure(2);
subplot(1,3,1); imhist(J(:,:,1));
subplot(1,3,2); imhist(J(:,:,2));
subplot(1,3,3); imhist(J(:,:,3));

%%
%Thresholding for blue color in macbeth chart, 2nd row 2nd col (from top
%left)
BW2 = (R>1) & (R<55) & (G>52) & (G<64) & (B>122) & (B<142);
figure(3);
imshow(BW2)
%%
%Thresholding for green color in Utagawa Hiroshige, bottom of the mountain
BW2 = (R>180) & (R<213) & (G>179) & (G<207) & (B>132) & (B<166);
figure(4); imagesc(BW2); colormap("gray");
%%
% Parametric segmentation using multivariate Gaussians
RI = double(reshape(I(:,:,1).',[],1)); GI = double(reshape(I(:,:,2).',[],1)); BI = double(reshape(I(:,:,3).',[],1));
RJ = reshape(J(:,:,1).', [], 1); GJ = reshape(J(:,:,2).', [], 1); BJ = reshape(J(:,:,3).', [], 1);
matI = double([RI, GI, BI]);
matJ = double([RJ, GJ, BJ]);
covJ = cov(matJ);
meanRJ = mean(RJ); meanGJ = mean(GJ); meanBJ = mean(BJ);
varRJ = var(double(RJ)); varGJ = var(double(GJ)); varBJ = var(double(BJ));
meanJ = [meanRJ,meanGJ,meanBJ];
mvnI = mvnpdf(matI,meanJ,covJ);
mvnI = mvnI./max(mvnI);
mvnorigI = reshape(mvnI,[size(I(:,:,1).')]);
mvnorigI = mvnorigI.';
figure(5); imagesc(mvnorigI); colormap("gray");
%%
% Parametric segmentation coming from joint 1D probabilities
pdfRI = normpdf(RI,meanRJ,1.6*sqrt(varRJ)); pdfGI = normpdf(GI,meanGJ,1.6*sqrt(varGJ)); pdfBI = normpdf(BI,meanBJ,1.6*sqrt(varBJ));
pdfI = pdfRI.*pdfGI.*pdfBI;
pdfI = pdfI./max(pdfI);
pdforigI = reshape(pdfI, [size(I(:,:,1).')]);
pdforigI = pdforigI.';
figure(6); imagesc(pdforigI); colormap("gray");
%% Histogram Backprojection Script
% MSoriano 2022
% Open an image and crop a region of interest

clear all ; close all;
BINS = 32;
[filename,pathname] = uigetfile('.jpg');
J = imread([pathname,filename]);
[I, rect] = imcrop(J);
%% Get the r g of the whole image
    J = double(J);
    R = J(:,:,1); G = J(:,:,2); B = J(:,:,3);
    Int= R + G + B;
    Int(Int==0)=100000; %to prevent NaNs
    rJ = R./ Int; gJ = G./Int;

%% Crop the region of interest in the rg space
     
    r = imcrop(rJ, rect);
    g = imcrop(gJ, rect);
    rint = round( r*(BINS-1) + 1);
    gint = round (g*(BINS-1) + 1);
    colors = gint(:) + (rint(:)-1)*BINS;
    
%% Compute rg-histogram
% This is the 1-d version of a 2-d histogram
    hist = zeros(BINS*BINS,1);
    for row = 1:BINS
    for col = 1:(BINS-row+1)
    hist(col+(row-1)*BINS) = length( find(colors==( ((col + (row-1)*BINS)))));
    end
    end

%% Backproject histogram
    rJint = round( rJ*(BINS-1) + 1);
    gJint = round (gJ*(BINS-1) + 1);
    colorsJ = gJint(:) + (rJint(:)-1)*BINS;
    HB = hist(colorsJ);
    HBImage = reshape(HB,size(J,[1,2]));
    HBImage = bwareaopen(HBImage,300);
    figure (2); imagesc(HBImage); 
    colormap (gray);

clear all; close all;
%% Load all available Neural Network Architectures and webcams
%Take note that the neural networks have different image sizes for
%classification
%cam = webcam;
nnet = alexnet; %image size [227, 227]
%nnet = googlenet; %image size [224,224]
%nnet= mobilenetv2; %image size [224,224]
%nnet= resnet50; %image size [224,224]
%% For live object classification
for i = 1:120 % number of snapshots; for a 60 fps camera, this takes 2 seconds
 img = cam.snapshot; %save snapshots per frame
 frame = imresize(img,[224,224]); % resize frames
 [label,score] = classify(nnet,frame);imshow(frame) % classify per frame
 title({upper(char(label)),num2str(max(score))}); % show final classification
end
%% For prerecorded object classification
vid = VideoReader("3183647145.mp4"); % load video using VideoReader
for i = 1:240 % change numbers according to preference; video loaded is about 4 seconds
 scrshot = read(vid,i); % take a screenshot
 frame = imresize(scrshot,[227,227]); % resize frames
 [label,score] = classify(nnet,frame);imshow(frame) % classify per frame
 title({upper(char(label)),num2str(max(score))}); % show final classification
end
clear all; close all; clc;
cam=webcam;
%obj.ReturnedColorspace = 'rgb';
preview(cam);
pause(5);
img = snapshot(cam);
[I, rect] = imcrop(img);
closePreview(cam);

framesAcquired = 0;
while (framesAcquired <= 120) 
    framesAcquired = framesAcquired+1;
    %data_yellow = imcomplement(obj.snapshot);  
    data=cam.snapshot;
    %data=imcomplement(data1);
    Bpdata = Backproject(data,rect);

    %diff_im = imsubtract(Bpdata, rgb2gray(double(data)));
    diff_im=medfilt2(Bpdata,[3 3]);
    diff_im=imbinarize(diff_im,0.1);
      
  
    % Remove all those pixels less than 300px
    diff_im = bwareaopen(diff_im,500);
    
    % Label all the connected components in the image.
    bw = bwlabel(diff_im, 8);
    
    % Here we do the image blob analysis.
    % We get a set of properties for each labeled region.
    stats = regionprops(bw, 'BoundingBox', 'Centroid');
    
    % Display the image
    %imshow(imcomplement(data_yellow))
    imshow(data)

    hold on
    
    %This is a loop to bound the red objects in a rectangular box.
    for object = 1:length(stats)
        bb = stats(object).BoundingBox;
        bc = stats(object).Centroid;
        rectangle('Position',bb,'EdgeColor','r','LineWidth',2)
        plot(bc(1),bc(2), '-m+')
        a=text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))), '    Y: ', num2str(round(bc(2)))));
        set(a, 'FontName', 'Times New Roman', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'red');
    end  
 
    hold off
end

%clear all
%% For prerecorded video
vid = VideoReader("pexels-ron-lach-7653591.mp4");
%obj.ReturnedColorspace = 'rgb';
img = readFrame(vid);
[I, rect] = imcrop(img);

framesAcquired=0;
while (framesAcquired <=120)
    %data_yellow = imcomplement(obj.snapshot);  
    data = readFrame(vid);
    %data=imcomplement(data1);
    Bpdata = Backproject(data,rect);

    %diff_im = imsubtract(Bpdata, rgb2gray(double(data)));
    diff_im=medfilt2(Bpdata,[3 3]);
    diff_im=imbinarize(diff_im,0.1);
      
  
    % Remove all those pixels less than 300px
    diff_im = bwareaopen(diff_im,500);
    
    % Label all the connected components in the image.
    bw = bwlabel(diff_im, 8);
    
    % Here we do the image blob analysis.
    % We get a set of properties for each labeled region.
    stats = regionprops(bw, 'BoundingBox', 'Centroid');
    
    % Display the image
    %imshow(imcomplement(data_yellow))
    imshow(data)

    hold on
    
    %This is a loop to bound the red objects in a rectangular box.
    for object = 1:length(stats)
        bb = stats(object).BoundingBox;
        bc = stats(object).Centroid;
        rectangle('Position',bb,'EdgeColor','r','LineWidth',2)
        plot(bc(1),bc(2), '-m+')
        a=text(bc(1)+15,bc(2), strcat('X: ', num2str(round(bc(1))), '    Y: ', num2str(round(bc(2)))));
        set(a, 'FontName', 'Times New Roman', 'FontWeight', 'bold', 'FontSize', 12, 'Color', 'red');
    end  
 
    hold off
end
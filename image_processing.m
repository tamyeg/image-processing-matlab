%% Lab1 
%% Task 1. Histogram Normalization 

clc;
clear;
close all;

images = {'Photo1.jpg', 'Photo2.jpg'};

% Process both images
for k = 1:2

    % Read image
    img = imread(images{k});

    % Convert to grayscale
    if size(img, 3) == 3
        img = rgb2gray(img);
    end

    if k == 1
        img1 = img;
    else
        img2 = img;
    end
    % Get image dimensions
    [rows, cols] = size(img);

    % Find minimum and maximum intensity
    minim = double(min(img(:)));
    maxim = double(max(img(:)));

    % Calculate intensity range
    range = maxim - minim;

    % Create empty normalized image
    normalized = zeros(rows, cols, 'uint8');

    % Histogram normalization - CODE 3.2
    for y = 1:rows
        for x = 1:cols
            if range > 0
                normalized(y,x) = floor( ...
                    (double(img(y,x)) - minim) * 255 / range);
            else
                normalized(y,x) = img(y,x);
            end
        end
    end

%% Display the results for task 1
    figure;

    subplot(2,2,1);
    imshow(img);
    title('Original Image');

    subplot(2,2,2);
    imshow(normalized);
    title('Normalized Image');

    subplot(2,2,3);
    imhist(img);
    title('Original Histogram');
    xlabel('Pixel Intensity');
    ylabel('Number of Pixels');

    subplot(2,2,4);
    imhist(normalized);
    title('Normalized Histogram');
    xlabel('Pixel Intensity');
    ylabel('Number of Pixels');

    sgtitle(['Experiment ', num2str(k)]);

%% Display the results of intensity values 
    fprintf('Original Min: %d\n', minim);
    fprintf('Original Max: %d\n', maxim);
    fprintf('Normalized Min: %d\n', min(normalized(:)));
    fprintf('Normalized Max: %d\n', max(normalized(:)));

end


for k = 1:2

    if k == 1
        img = img1;
    else
        img = img2;
    end

    % My normalization (CODE 3.2)
    minimum = double(min(img(:)));
    maximum = double(max(img(:)));

    normalized = floor((double(img) - minimum) * 255 / ...
                       (maximum - minimum));
    normalized = uint8(normalized);

%% MATLAB built-in normalization
    low = minimum / 255;
    high = maximum / 255;

    built_in = imadjust(img, [low high], [0 1]);

%% Display results
    figure;

    subplot(1,3,1);
    imshow(img);
    title('Original Image');

    subplot(1,3,2);
    imshow(normalized);
    title('My Normalization');

    subplot(1,3,3);
    imshow(built_in);
    title('MATLAB imadjust');

end


%% Task 2. Convolution 
average = ones(3,3)/9;
sharpen = [0 -1 0; -1 5 -1; 0 -1 0];

for k = 1:2

    if k == 1
        img = img1;
    else
        img = img2;
    end

    img = imresize(img, 0.25);
    [rows, cols] = size(img);

    smooth = zeros(rows, cols);
    sharp = zeros(rows, cols);

    % My convolution
    for y = 2:rows-1
        for x = 2:cols-1
            for i = 1:3
                for j = 1:3
                    pixel = double(img(y+i-2,x+j-2));

                    smooth(y,x) = smooth(y,x) + pixel*average(i,j);
                    sharp(y,x) = sharp(y,x) + pixel*sharpen(i,j);
                end
            end
        end
    end

%% MATLAB built-in convolution
    built_smooth = imfilter(double(img), average, 0, 'conv');
    built_sharp = imfilter(double(img), sharpen, 0, 'conv');

    % Match the borders
    built_smooth([1 end],:) = 0;
    built_smooth(:,[1 end]) = 0;
    built_sharp([1 end],:) = 0;
    built_sharp(:,[1 end]) = 0;

    % Normalize all results
    results = {smooth, built_smooth, sharp, built_sharp};

    for n = 1:4
        result = results{n};
        minimum = min(result(:));
        maximum = max(result(:));

        if maximum > minimum
            result = floor((result-minimum)*255/(maximum-minimum));
        end

        results{n} = uint8(result);
    end

    
    figure;
    subplot(1,3,1); imshow(img); title('Original');
    subplot(1,3,2); imshow(results{1}); title('Averaging 3x3');
    subplot(1,3,3); imshow(results{3}); title('Sharpening 3x3');

    
    figure;
    subplot(2,2,1); imshow(results{1}); title('My Averaging');
    subplot(2,2,2); imshow(results{2}); title('MATLAB Averaging');
    subplot(2,2,3); imshow(results{3}); title('My Sharpening');
    subplot(2,2,4); imshow(results{4}); title('MATLAB Sharpening');

end


%% Task 3. Gaussian Averaging 

sigma = 1;
sizes = [3, 5];

for k = 1:2

    if k == 1
        img = img1;
    else
        img = img2;
    end

    img = imresize(img, 0.25);
    [rows, cols] = size(img);

    figure;

    subplot(1,3,1);
    imshow(img);
    title('Original Image');

    for n = 1:2

        winsize = sizes(n);
        half = floor(winsize/2);
        template = zeros(winsize);

        % Create Gaussian template (CODE 3.9)
        for i = 1:winsize
            for j = 1:winsize
                template(i,j) = exp(-((i-half-1)^2 + ...
                    (j-half-1)^2)/(2*sigma^2));
            end
        end

        template = template / sum(template(:));

        % My Gaussian averaging
        result = zeros(rows, cols);

        for y = half+1:rows-half
            for x = half+1:cols-half
                for i = 1:winsize
                    for j = 1:winsize
                        result(y,x) = result(y,x) + ...
                            double(img(y+i-half-1,x+j-half-1)) ...
                            * template(i,j);
                    end
                end
            end
        end

%% MATLAB built-in functions
        built_template = fspecial('gaussian', winsize, sigma);
        built_in = imfilter(double(img), built_template, 0, 'conv');

        % Use the same borders
        built_in(1:half,:) = 0;
        built_in(end-half+1:end,:) = 0;
        built_in(:,1:half) = 0;
        built_in(:,end-half+1:end) = 0;

        % Normalize both results
        result = floor(255 * result / max(result(:)));
        built_in = floor(255 * built_in / max(built_in(:)));

        % Save results for comparison
        if n == 1
            my3 = uint8(result);
            matlab3 = uint8(built_in);
        else
            my5 = uint8(result);
            matlab5 = uint8(built_in);
        end

%% Display manual result
        subplot(1,3,n+1);
        imshow(uint8(result));

        if n == 1
            title('Gaussian 3x3');
        else
            title('Gaussian 5x5');
        end

    end

  
    figure;

    subplot(2,2,1);
    imshow(my3);
    title('My Gaussian 3x3');

    subplot(2,2,2);
    imshow(matlab3);
    title('MATLAB Gaussian 3x3');

    subplot(2,2,3);
    imshow(my5);
    title('My Gaussian 5x5');

    subplot(2,2,4);
    imshow(matlab5);
    title('MATLAB Gaussian 5x5');

end



%% Task 4. Morphological Erosion 

sizes = [3, 5];

for k = 1:2

    if k == 1
        img = img1;
    else
        img = img2;
    end

    img = imresize(img, 0.25);
    [rows, cols] = size(img);

    for n = 1:2

        winsize = sizes(n);
        half = floor(winsize/2);
        template = zeros(winsize);

        % My erosion (CODE 3.15)
        eroded = zeros(rows, cols, 'uint8');

        for y = half+1:rows-half
            for x = half+1:cols-half

                minimum = 256;

                for i = 1:winsize
                    for j = 1:winsize

                        pixel = double(img(y+j-half-1, x+i-half-1));
                        value = pixel - template(j,i);

                        if value < minimum
                            minimum = value;
                        end

                    end
                end

                eroded(y,x) = uint8(minimum);

            end
        end

%% MATLAB built-in erosion
        built_in = imerode(img, ones(winsize));

        % Match the borders
        built_in(1:half,:) = 0;
        built_in(end-half+1:end,:) = 0;
        built_in(:,1:half) = 0;
        built_in(:,end-half+1:end) = 0;

        % Save results
        if n == 1
            my3 = eroded;
            matlab3 = built_in;
        else
            my5 = eroded;
            matlab5 = built_in;
        end

    end

%% Display original and manual results
    figure;

    subplot(1,3,1);
    imshow(img);
    title('Original Image');

    subplot(1,3,2);
    imshow(my3);
    title('Erosion 3x3');

    subplot(1,3,3);
    imshow(my5);
    title('Erosion 5x5');

    figure;

    subplot(2,2,1);
    imshow(my3);
    title('My Erosion 3x3');

    subplot(2,2,2);
    imshow(matlab3);
    title('MATLAB Erosion 3x3');

    subplot(2,2,3);
    imshow(my5);
    title('My Erosion 5x5');

    subplot(2,2,4);
    imshow(matlab5);
    title('MATLAB Erosion 5x5');

end



%% Task 5. Morphological Dilation 
sizes = [3, 5];

for k = 1:2

    if k == 1
        img = img1;
    else
        img = img2;
    end

    img = imresize(img, 0.25);
    [rows, cols] = size(img);

    for n = 1:2

        winsize = sizes(n);
        half = floor(winsize/2);
        template = zeros(winsize);

%% My dilation (CODE 3.16)
        dilated = zeros(rows, cols, 'uint8');

        for y = half+1:rows-half
            for x = half+1:cols-half

                maximum = 0;

                for i = 1:winsize
                    for j = 1:winsize
                        pixel = double(img(y+i-half-1, x+j-half-1));
                        value = pixel + template(i,j);

                        if value > maximum
                            maximum = value;
                        end
                    end
                end

                dilated(y,x) = uint8(maximum);
            end
        end

%% MATLAB built-in dilation
        built_in = imdilate(img, ones(winsize));

        % Use the same borders
        built_in(1:half,:) = 0;
        built_in(end-half+1:end,:) = 0;
        built_in(:,1:half) = 0;
        built_in(:,end-half+1:end) = 0;

 %% Display comparison
        if n == 1
            my3 = dilated;
            matlab3 = built_in;
        else
            my5 = dilated;
            matlab5 = built_in;
        end
    end

 
    figure;
    subplot(1,3,1); imshow(img); title('Original Image');
    subplot(1,3,2); imshow(my3); title('Dilation 3x3');
    subplot(1,3,3); imshow(my5); title('Dilation 5x5');

  
    figure;
    subplot(2,2,1); imshow(my3); title('My Dilation 3x3');
    subplot(2,2,2); imshow(matlab3); title('MATLAB Dilation 3x3');
    subplot(2,2,3); imshow(my5); title('My Dilation 5x5');
    subplot(2,2,4); imshow(matlab5); title('MATLAB Dilation 5x5');

end
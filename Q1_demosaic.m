%read image as matrix of doubles for compatibility with conv2
image = im2double(imread("demosaic_image.png"));

%split image into 3 channels
RChannel = image(:,:,1); 
GChannel = image(:,:,2); 
BChannel = image(:,:,3); 

%initialize matrices to store bayer pattern sampled channels
RBayer = zeros(size(RChannel));
GBayer = zeros(size(GChannel));
BBayer = zeros(size(BChannel));

%corresponding pixels from channels are copied according to 'rggb' pattern
RBayer(1:2:end, 1:2:end) = RChannel(1:2:end, 1:2:end);
GBayer(1:2:end, 2:2:end) = GChannel(1:2:end, 2:2:end);
GBayer(2:2:end, 1:2:end) = GChannel(2:2:end, 1:2:end);
BBayer(2:2:end, 2:2:end) = BChannel(2:2:end, 2:2:end);

%filters encode linear interpolation, red and blue filters are the same
Rfilter = [0.25, 0.5, 0.25; 0.5, 1.0, 0.5; 0.25, 0.5, 0.25];
Gfilter = [0.0, 0.25, 0.0; 0.25, 1.0, 0.25; 0.0, 0.25, 0.0];
Bfilter = Rfilter;

RInt = conv2(RBayer, Rfilter, 'valid');
GInt = conv2(GBayer, Gfilter, 'valid');
BInt = conv2(BBayer, Bfilter, 'valid');

% RInt = conv2(RBayer, Rfilter, 'full');
% GInt = conv2(GBayer, Gfilter, 'full');
% BInt = conv2(BBayer, Bfilter, 'full');

%concatenate 3 interpolated layers to form an image
final = cat(3, RInt, GInt, BInt);

figure, imshow(final);
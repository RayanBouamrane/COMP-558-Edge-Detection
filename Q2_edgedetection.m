%set rng seed for reproducibility when analysing
rng(2);

%create blank, all white 400x400 image
unCropped = 255 .* ones(400,400, 'uint8');

for i = 1:25

%rectangles will be between 25 and 150 pixels tall and wide
rHeight = cast(rand * 125 + 25, 'uint16');
rWidth = cast(rand * 125 + 25, 'uint16');

rColour = cast(rand * 255, 'uint8');

%rXPos and rYPos denote the location the 
%top left pixel of a rectangle will be
rXPos = cast(rand * (400 - rWidth) + 1, 'uint16');
rYPos = cast(rand * (400 - rHeight) + 1, 'uint16');

%rColour added to every pixel from left to right, up to down
%according to height and width of rectagle 
unCropped(rXPos:1:rXPos+rWidth, rYPos:1:rYPos+rHeight) = rColour;

end

%cropped image has middle 250x250 pixels of uncropped image
image = unCropped(75:1:324, 75:1:324);

% Laplacian of Gaussian created, size 20, sigma 3
filt = fspecial('log',20,3);

% % Q2e) Laplacian of Gaussian, size 40, sigma 6
% filt = fspecial ('log', 40, 6);

% % Q2b) show image of filter.
% % to increase contrast when showing image, filter is scaled up
% % scale by 500 for sigma 3, 10000 for sigma 6
% imshow(500.*filt);
% truesize([200 200]);
% c = colorbar;

% % Q2d) noisy image, comment out code below for no noise image
stddev = std2(image)/10;

% random normally distributed values created, scaled by stddev
% cast to 16bit int to store -256 to +255
noise = cast(stddev.*randn(250, 250), 'int16');

% cast original image to allow adding noise and image
im16 = cast(image, 'int16');
image = cast(noise + im16, 'uint8'); 

% % end of 2d)

% convolve
log = conv2(image, filt, 'same'); 

% compare Laplacian of Gaussian filtered image by neighbours
% in four directions: x, y and both diagonals
% if product less than 0, zero crossing present
zCHor = 0 > log .* circshift(log, 1);
zCVer = 0 > log .* circshift(log, 1,2);
zCDiag1 = 0 > log .* circshift(log, [1 1]);
zCDiag2 = 0 > log .* circshift(log, [-1 -1]);

% add all four directions to get all zero crossings
zeroCrossings = (zCHor | zCVer | zCDiag1 | zCDiag2);

% figure, imshow(image);
% figure, imshow(500.*filt); figure, imshow(10000.*filt);
% figure, imshow(log);
% figure, imshow(255.*zeroCrossings);
clc;
close all;

% 来自论文《Non-Local Means Denoising》
% 这个有pixel级和块级两个版本

% filePath      = 'C:\数据空间\ISP\image\standard\';
fileName      = 'lena';
fmat          = '.bmp';

input_raw     = imread([fileName, fmat]);
% [m,n,k]       = size(input_raw);
src           = double(input_raw)/256;
src_yuv       = rgb2ycbcr(src);
% input_image   = src_yuv(:,:,1);
[m,n,k]       = size(src);
% figure,imshow(src),title('src');

%% 加噪
src_noise  = imnoise(src_yuv(:,:,1), 'gaussian', 0, 0.003); % 加入高斯噪声
% src_noise  = imnoise(src_yuv(:,:,1), 'salt & pepper', 0.01); % 加入椒盐噪声
figure,imshow(src_noise),title('src_noise');

%% nlm, pixel级
cur_win   = 3;
ser_win   = 5;
nlm_sigma = 0.05;
nlm_h     = 0.03;

% tic;
% nlm_fast  = nlm_pixel_fast(src_noise, ser_win, cur_win, nlm_sigma, nlm_h);
% figure,imshow(nlm_fast),title('nlm_pixel_fast');
% toc;

tic;
nlm_out   = nlm_pixel(src_noise, ser_win, cur_win, nlm_sigma, nlm_h);
figure,imshow(nlm_out),title('nlm_pixel');
toc;

%% nlm，block级，但是只取中心点像素
% nlm_h越小，保边效果越好
cur_win   = 3;
ser_win   = 5;
nlm_sigma = 0.05;
nlm_h     = 0.05;
% tic;
% nlm_fast  = nlm_block_fast(src_noise, ser_win, cur_win, nlm_sigma, nlm_h);
% figure,imshow(nlm_fast),title('nlm_block_fast');
% toc;

tic;
nlm_out   = nlm_block(src_noise, ser_win, cur_win, nlm_sigma, nlm_h);
figure,imshow(nlm_out),title('nlm_block');
toc;

%% 双边滤波
win_m      = 8;
win_n      = win_m;
sigma_range= 0.1;

sigma_space= 5;
[x,y] = meshgrid(-win_m:1:win_m,-win_n:1:win_n);
space_ker = exp(-(x.^2+y.^2)/(2*sigma_space^2));%/(2*pi*sigma_space^2);

tic;
bil       = bilateral_filter(src_noise, src_noise, win_m, win_n, sigma_range, space_ker);
toc;
figure,imshow(bil),title("bil");

% tic;
% bil_fast  = bilateral_fast(src_noise, src_noise, win_m, win_n, sigma_range, space_ker);
% toc;
% figure,imshow(bil_fast),title("bil_fast");








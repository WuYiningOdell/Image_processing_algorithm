function output = bilateral_filter(pic_in, guide, win_m, win_n, sigma_range, space_ker)
%BILAT Summary of this function goes here
%   Detailed explanation goes here
%   双边滤波函数
%   pic_in: 输入数据
%   guide:  导向图
%   win_m:  垂直方向半径
%   win_n:  水平方向半径
%   sigma_range: 值域exp函数的sigma
%   sigma_ker:   kernel的sigma

[m,n]      = size(pic_in);
output     = zeros(m,n);
% value_sum  = zeros(m,n);
% weight_sum = zeros(m,n);

% pad_hgt    = win_m;
% pad_wid    = win_n;
% guide_pad  = padarray(guide, [pad_hgt, pad_wid], 'replicate');
% pic_in_pad = padarray(pic_in, [pad_hgt, pad_wid], 'replicate');

% kernel     = fspecial('gaussian', [win_m,win_n], sigma_ker);

for i = 1 : m
    for j = 1 : n
        i_range    = i-win_m : i+win_m;
        i_range    = max(1,i_range);
        i_range    = min(m,i_range);
        j_range    = j-win_n : j+win_n;
        j_range    = max(1,j_range);
        j_range    = min(n,j_range);
        src_blk    = pic_in(i_range,j_range);
        guide_blk  = guide (i_range,j_range);
        blk_center = guide(i,j);
        diff       = abs(blk_center - guide_blk);
        range_ker  = exp(-(diff.^2)/(2*sigma_range^2));%exp(-(diff.^2)/(2*sigma_range^2));
        wet        = range_ker .* space_ker;
        value      = wet .* src_blk;
        
        weight_sum = sum(wet(:));
        value_sum  = sum(value(:));
        output(i,j)= value_sum/weight_sum;
    end
end


end


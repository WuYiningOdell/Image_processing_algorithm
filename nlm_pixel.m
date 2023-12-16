function output = nlm_pixel(pic_in, ser_win, cur_win, sigma, h)
%BILAT Summary of this function goes here
%   Detailed explanation goes here
%   no-local mean滤波函数
%   pic_in: 输入数据
%   ser_win: 搜索窗口的大小
%   ser_blk: 搜索块的大小
%   sigma: 相似度匹配阈值
%   h: 滤波强度

[m,n]      = size(pic_in);
ser_radius = floor(ser_win/2);
cur_radius = floor(cur_win/2);
ser_size   = ser_win - cur_win + 1;
output     = zeros(m,n);

for i = 1 : m
    for j = 1 : n
        % 当前块
        x           = i-cur_radius : i+cur_radius;
        y           = j-cur_radius : j+cur_radius;
        x           = min(max(x,1), m);
        y           = min(max(y,1), n);
        ref_blk     = pic_in(x,y);
        % 搜索块
        xx          = i-ser_radius : i+ser_radius;
        yy          = j-ser_radius : j+ser_radius;
        xx          = min(max(xx,1), m);
        yy          = min(max(yy,1), n);
        ser_blk     = pic_in(xx,yy); 
        % 初始化diff_avg
        diff_avg    = zeros(ser_size,ser_size);
        for s = 1 : ser_size  % 在搜索窗口里面计算匹配块
            for t = 1 : ser_size
                aa            = s : s+cur_win-1;
                bb            = t : t+cur_win-1;

                cur_blk       = ser_blk(aa,bb);  % 取当前块数据大小
                diff          = (cur_blk - ref_blk);
                diff          = diff.^2; 
                diff_avg(s,t) = mean(diff(:));
            end
        end
        
        diff_max    = max(diff_avg - 2*sigma^2, 0);
        cur_wet     = exp(-diff_max/(h^2));
        
        % 搜索的数据点很多，实际参与滤波的窗口其实很大
        flt_sta     = cur_radius + 1;
        flt_end     = flt_sta+ser_size-1;
        flt_blk     = ser_blk(flt_sta:flt_end,flt_sta:flt_end);
        
        cur_value   = cur_wet .* flt_blk;
        nr_flt      = sum(cur_value(:))/(sum(cur_wet(:)));
        output(i,j) = nr_flt;
    end
end


end


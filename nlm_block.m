function output = nlm_block(pic_in, ser_win, cur_win, sigma, h)
%BILAT Summary of this function goes here
%   Detailed explanation goes here
%   no-local mean�˲�����
%   pic_in: ��������
%   ser_win: �������ڵĴ�С
%   ser_blk: ������Ĵ�С
%   sigma: ���ƶ�ƥ����ֵ
%   h: �˲�ǿ��

[m,n]      = size(pic_in);
ser_radius = floor(ser_win/2);
cur_radius = floor(cur_win/2);
ser_size   = ser_win - cur_win + 1;
output     = zeros(m,n);

for i = 1 : m
    for j = 1 : n
        % ��ǰ��
        x           = i-cur_radius : i+cur_radius;
        y           = j-cur_radius : j+cur_radius;
        x           = min(max(x,1), m);
        y           = min(max(y,1), n);
        ref_blk     = pic_in(x,y);
        % ������
        xx          = i-ser_radius : i+ser_radius;
        yy          = j-ser_radius : j+ser_radius;
        xx          = min(max(xx,1), m);
        yy          = min(max(yy,1), n);
        ser_blk     = pic_in(xx,yy); 
        % ��ʼ��
        blk_value   = zeros(cur_win,cur_win);
        blk_weight  = zeros(cur_win,cur_win);
        for s = 1 : ser_size  % �����������������ƥ���
            for t = 1 : ser_size
                aa            = s : s+cur_win-1;
                bb            = t : t+cur_win-1;

                cur_blk       = ser_blk(aa,bb);  % ȡ��ǰ�����ݴ�С
                diff          = (cur_blk - ref_blk);
                diff          = diff.^2; 
                diff_max      = max(diff - 2*sigma^2, 0);
                cur_wet       = exp(-diff_max/(h^2));
                
                cur_value     = cur_wet .* cur_blk;
                blk_value     = blk_value + cur_value;
                blk_weight    = blk_weight + cur_wet;
            end
        end
        out_blk     = blk_value ./ blk_weight;
        output(i,j) = out_blk(cur_radius+1,cur_radius+1);
    end
end

end


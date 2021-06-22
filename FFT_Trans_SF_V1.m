function [Im1,Im2,imtrans,Score] = FFT_Trans_SF_V1(I1,I2)
%UNTITLED2 �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

    FI1 = fft2(I1);
    FI2 = fft2(I2);
    
    FR = FI1.*conj(FI2); % calculating correlation
    
    R = ifft2(FR);
    R = fftshift(R);
    R=R-min(R(:));
    R=R/mean(R(:));
    
    num = find(R==max(R(:)));
    [i,j] = ind2sub(size(R), num);
    offset_row = i-round(size(I1,1)/2);
    offset_col = j-round(size(I1,2)/2);
    imtrans=[offset_col offset_row ];
    I2_imtrans=imtranslate(I2,imtrans);
    
    Im1=I1;
    Im2=I2_imtrans;
    Score=R;
end


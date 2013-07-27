clear all;
clc;
%----------------------------- parameters----------------------------------
SNR = 1:0.5:4;
frame = zeros(2,length(SNR));
nframe = zeros(2,length(SNR));

rate_right=zeros(1,length(SNR));
rate_wrong=zeros(1,length(SNR));
        
 %generate the wrong keys
 key1 = randi([1,10000],1);
 while key1 == 110
     key1 = randi([1,10000],1);
 end
key2 = randi([1,10000],1);
 while key2 == 34
     key2 = randi([1,10000],1);
 end
 key3 = randi([1,10000],1);
 while key3 == 91
     key3 = randi([1,10000],1);
 end
 %------------------------------------------------------------------------
 
 fprintf('Parameters are set as:\n');
 fprintf('SNR = %d\n',SNR);
 fprintf('Please wait to get tht results\n');
 
for ii= 1: length(SNR)
    
    fprintf('SNR: %d\n',SNR(ii));
    
    while nframe(1,ii)<100 || nframe(2,ii)<100
        
        frame(1,ii) = frame(1,ii) + 1;
        frame(2,ii) = frame(2,ii) + 1;
        fprintf('frame: %d\n',frame(1,ii));
     
        rate_r = sccc_sim(SNR(ii),110,34,91);
        rate_w = sccc_sim(SNR(ii),key1,key2,key3);
        
        nframe(1,ii) = nframe(1,ii) + (rate_r>0);
        nframe(2,ii) = nframe(2,ii) + (rate_w>0);
        
        rate_right(ii) = rate_right(ii) + rate_r;
        rate_wrong(ii) = rate_wrong(ii) + rate_w;
        
    end
    
    rate_right(ii) = rate_right(ii)/frame(1,ii);
    rate_wrong(ii) = rate_wrong(ii)/frame(2,ii);
    
end

semilogy(SNR,rate_right,'bs-');
hold on;
grid on;
semilogy(SNR,rate_wrong,'rd-');
hold off;
xlabel('SNR');
ylabel('Bit Error Rate');
title('Comparation between two receives');
legend('authorized receiver','unauthorized receiver');
 
    
    
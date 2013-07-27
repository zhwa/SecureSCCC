% File: simulate_sccc_ofdm.m, simulate a ofdm system under Nakagami channel
% the parameter m is set to be 0.75, 1.0, 5 respecticely
% when m=1.0 the channel becomes Rayleigh channel
clear all;
clc;

% set up parameters
m = [0.75 1.0 5];
SNR = 1:0.5:4;
ErrorBits_r = zeros(length(m),length(SNR));
ErrorBits_w = zeros(length(m),length(SNR));
nframe_r = zeros(length(m),length(SNR));
nframe_w = zeros(length(m),length(SNR));
frame = zeros(length(m),length(SNR));
BitErrorRate_r = zeros(length(m),length(SNR));
BitErrorRate_w = zeros(length(m),length(SNR));


% Generate 3 wrong keys
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

 fprintf('Parameters are ready:\n');
 fprintf('FFT size: 64 \n');
 fprintf('subcarriers for data transmittion: 50 \n');
 fprintf('number of Taps: 10 \n');
 
for i = 1:length(m)
    for j = 1:length(SNR)
        while nframe_r(i,j)<100 || nframe_w(i,j)<100
            ErrorBit_r = OFDMSystem(SNR(j),m(i),110,34,91);
            ErrorBits_r(i,j) = ErrorBits_r(i,j) + ErrorBit_r;
            nframe_r(i,j) = nframe_r(i,j) + (ErrorBit_r>0);
            frame(i,j) = frame(i,j)+1;
            ErrorBit_w = OFDMSystem(SNR(j),m(i),key1,key2,key3);
            ErrorBits_w(i,j) = ErrorBits_w(i,j) + ErrorBit_w;
            nframe_w(i,j) = nframe_w(i,j) + (ErrorBit_w>0);
            fprintf('m=%d,SNR=%d,frame=%d \n',m(i),SNR(j),frame(i,j));
        end
        BitErrorRate_r(i,j) = ErrorBits_r(i,j)/(800*frame(i,j));
        BitErrorRate_w(i,j) = ErrorBits_w(i,j)/(800*frame(i,j));
    end
end

semilogy(SNR,BitErrorRate_r(1,:),'bs-');hold on;
semilogy(SNR,BitErrorRate_r(2,:),'ro-');hold on;
semilogy(SNR,BitErrorRate_r(3,:),'m*-');hold on;
legend('m=0.5','m=1.0','m=5.0');
semilogy(SNR,BitErrorRate_w(1,:),'bs-');hold on;
semilogy(SNR,BitErrorRate_w(2,:),'ro-');hold on;
semilogy(SNR,BitErrorRate_w(3,:),'m*-');hold on;
xlabel('SNR')
ylabel('Bit Error Rate')
title('BER for BPSK using OFDM in a 10-tap Rayleigh channel')
grid on;
hold off;

function ErrorBit = OFDMSystem(EbN0dB,m,key1,key2,key3)
% This function perform OFDM simulation under Nakagami channel
%
%
%----------------------parameters set up-----------------------------------
nFFT        = 64; % fft size
nDSC        = 50; % number of data subcarriers
nBitPerSym  = 50; % number of bits per OFDM symbol (same as the number of subcarriers for BPSK)
nSym        = 64; % number of symbols = 3200/50

EsN0dB      = EbN0dB + 10*log10(nDSC/nFFT) + 10*log10(64/80); % converting to symbol to noise ratio

% fading factor a for nTap
nTap = 10;
%--------------------------------------------------------------------------
g_out = [ 1 1 1; 1 0 1 ];   g_in = [ 1 1 1;  1 0 1 ];
L_s = 40;	
[n_out,K] = size(g_out);
L_total = (L_s^2)/n_out; % information bits' length
[n_in,K_in] = size(g_in);
%--------------------------------------------------------------------------
matrix = 1:L_s^2;
matrix = reshape(matrix,L_s,L_s).';
permution=hashdisturb(matrix,1,110,34,91);
alpha = reshape(permution,1,L_s^2);
%-------------------------------------------------------------------------
%--------------------------------------------------------------------------

% Transmitter
x = round(rand(1, L_total));                  
ipMod = encoder( x, g_out,g_in, alpha) ;  % encoder output (+1/-1)
ipMod = reshape(ipMod,nBitPerSym,nSym).'; % grouping into multiple symbolsa
    
% Assigning modulated symbols to subcarriers from [-25 to -1, +1 to +25]
xF = [zeros(nSym,7) ipMod(:,[1:nBitPerSym/2]) zeros(nSym,1) ipMod(:,[nBitPerSym/2+1:nBitPerSym]) zeros(nSym,6)] ;
   
% Taking FFT, the term (nFFT/sqrt(nDSC)) is for normalizing the power of transmit symbol to 1 
xt = (nFFT/sqrt(nDSC))*ifft(fftshift(xF.')).';
    
% Appending cylic prefix
xt = [xt(:,[49:64]) xt];
    
% multipath channel
% nakagami parameter m: m>=1/2; when m = 1 nakagami turns to rayleigh and when m = 1.5 it becomes rice 

ht = 1/sqrt(nTap)*reshape(DiscontinuousNakagami(m,1,nTap,nSym),nSym,nTap);
   
% computing and storing the frequency response of the channel, for use at recevier
hF = fftshift(fft(ht,64,2));
    
% convolution of each symbol with the random channel
for jj = 1:nSym
    xht(jj,:) = conv(ht(jj,:),xt(jj,:));
end
xt = xht;
    
% Concatenating multiple symbols to form a long vector
xt = reshape(xt.',1,nSym*(80+nTap-1));
    
% Gaussian noise of unit variance, 0 mean
nt = 1/sqrt(2)*[randn(1,nSym*(80+nTap-1)) + 1i*randn(1,nSym*(80+nTap-1))];
    
    
% Adding noise, the term sqrt(80/64) is to account for the wasted energy due to cyclic prefix
yt = sqrt(80/64)*xt + 10^(-EsN0dB/20)*nt;
        
% Receiver
yt = reshape(yt,80+nTap-1,nSym).'; % formatting the received vector into symbols
yt = yt(:,[17:80]); % removing cyclic prefix
    
% converting to frequency domain
yF = (sqrt(nDSC)/nFFT)*fftshift(fft(yt.')).'; 
    
% equalization by the known channel frequency response
yF = yF./hF;
    
% extracting the required data subcarriers
yMod = yF(:,[7+[1:nBitPerSym/2] 8+[nBitPerSym/2+1:nBitPerSym] ]); 
   
% BPSK demodulation
ipModHat = real(yMod);
        

% converting modulated values into bits
ipSymHat = reshape(ipModHat.',nBitPerSym*nSym,1).';

% soft decoding
ipBitHat = decoder(ipSymHat,matrix,key1,key2,key3,g_in,g_out,L_s);

% counting the errors
ErrorBit = sum(abs(ipBitHat - x));


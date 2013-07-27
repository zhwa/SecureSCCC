function rat = sccc_sim(SNR,key1,key2,key3)

%----------------------------parameters------------------------------------
    g_out = [ 1 1 1; 1 0 1 ];   
    g_in = [ 1 1 1;  1 0 1 ];
    L_s = 40;	
    [n_out,K] = size(g_out);
    L_total = (L_s^2)/n_out;                            % information bits' length
    [n_in,K_in] = size(g_in);
    EbN0db = SNR;
%--------------------------------------------------------------------------
    matrix = 1:L_s^2;
    matrix = reshape(matrix,L_s,L_s).';
    permution=hashdisturb(matrix,1,110,34,91);
    alpha = reshape(permution,1,L_s^2);
%-------------------------------------------------------------------------

    x = round(rand(1, L_total));                        % info. bits
      
%-----------------------encode the information bits------------------------
    en_output = encoder( x, g_out,g_in, alpha) ;        % encoder output (+1/-1)
%--------------------------------------------------------------------------    


    en = 10^(EbN0db/10);                                 % convert Eb/N0 from unit db to normal numbers
    rate=1/(n_out+n_in);
    L_c = 4*en*rate;                                     % reliability value of the channel
    sigma = 1/sqrt(2*rate*en);                           % standard deviation of AWGN noise
    r = en_output+sigma*randn(1,L_total*(n_out+n_in));   % received bits
    rec_s = 0.5*L_c*r;  
%----------------------------decoder---------------------------------------
    L_a = zeros(1,length(rec_s)/2);
    permution_1=hashdisturb(matrix,1,key1,key2,key3);
    beta = reshape(permution_1,1,L_s^2);
    for iter = 1:8
        L_in = sova(rec_s, g_in, L_a, 2);                    
        L_middle(beta) = L_in;
        L_out = sova(L_middle,g_out,zeros(1,length(L_in)/2),2);
        L_e = L_out - L_middle(1:2:length(L_middle)-1);
        L_a = zeros(1,length(rec_s)/2);
        L_a(1:2:length(rec_s)/2-1) = L_e;
        L_a = L_a(beta);
    end
%--------------------------------------------------------------------------
    y = (sign(L_out)+1)/2;
    [~,rate] = biterr(x,y);
    rat=rate;
end
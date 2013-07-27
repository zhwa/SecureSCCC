function ipBitHat = decoder(ipSymHat,matrix,key1,key2,key3,g_in,g_out,L_s)

    L_a = zeros(1,length(ipSymHat)/2);
    permution_1=hashdisturb(matrix,1,key1,key2,key3);
    beta = reshape(permution_1,1,L_s^2);

    L_in = sova(ipSymHat, g_in, L_a, 2);                    
    L_middle(beta) = L_in;
    L_out = sova(L_middle,g_out,zeros(1,length(L_in)/2),2);
    ipBitHat = (sign(L_out)+1)/2;
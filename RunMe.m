% This programme can be used for acadamic purpose only
% Everyone can use and redistribute it without extra restriction
% Many functions are provided by the open source community. Great thanks
% to their sharing.
%
% 
% File: RunMe.m, simulation of sccc under different conditions
clc;clear all;
disp(' ===============================================================================');
disp(' *                                                                             *');
disp(' *                        " siulations of sccc  "                              *');
disp(' *                        ASIC Research Center, SEU                            *');
disp(' *                                                                             *');
disp(' ===============================================================================');

kk = 0;
while kk == 0
    k = menu('To  Simulate different experients, please enter your choice:',...
        '1  | Generate a matrix and disturb it using the hash distrubing algorithm',...
        '2  | Read in a picture and disturb it using the hash disturbing algorithm',...
        '3  | Compare the bits error rates of two receivers under the AWGN channel',...
        '4  | Compare two receivers decoding results of a picture transmit through the AWGN channel',...
        '5  | Compare the bits error rates of two receivers under the Nakagami-m channel',...
        '6  | Exit Simulation');
    if k == 1
        clear all;
        clc;
        kk = 0;
        L = input('Please input the parameter L for a L*L matrix(default:8) > ');
        if(isempty(L))
            L = 8;
        end
        key = input('Please input 3 keys in the format [key1 key2 key3] > ');
        m = 1:1:L^2;
        m = reshape(m,L,L).'
        permution = hashdisturb(m,1,key(1),key(2),key(3))
        pause;
    elseif k == 2
        clear all;
        clc;
        kk = 0;
        disp('This simulation will use mark.bmp for demonstration');
        image=imread('mark.bmp'); %use picture lena.bmp as the matrix
        result = hashdisturb(image,1,1983,421,1121);
        imwrite(result,'mark_s.bmp','bmp');
        result_back = hashdisturb(result,0,1983,421,1121);
        imwrite(result_back,'mark_b.bmp','bmp');
        disp('Pictures have been prepared! Please check them outside Matlab');
        pause;
    elseif k == 3
        run simulate_sccc_bpsk_compare;
        kk = 0;
        pause;
    elseif k == 4
        run simulate_picture_bpsk_compare;
        kk = 0;
        pause;
    elseif k == 5
        run simulate_sccc_ofdm;
        kk = 0;
        pause;
    elseif k == 6
        kk = 1;
    end
end


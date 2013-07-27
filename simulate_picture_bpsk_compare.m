clear all;
clc;
SNR=3;

%--------------------------------------------------------------------------
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
 %-------------------------------------------------------------------------
 
image=imread('seu.bmp'); %use picture lena.bmp as the matrix

for i=1:50
    for j=1:800
        x = ceil((800*(i-1)+j)/200);
        if rem((800*(i-1)+j),200)>0
            y = rem(800*(i-1)+j,200);
        else
            y=200;
        end
        matrix(i,j) = image(x,y);
    end
end

for i=1:50
    matrix_right(i,:) = sccc_sim_picture(matrix(i,:), SNR,110,34,91);
    matrix_wrong(i,:) = sccc_sim_picture(matrix(i,:),SNR,key1,key2,key3);
end


for i=1:50
    for j=1:800
    matrix_r(800*(i-1)+j) = matrix_right(i,j);
    matrix_w(800*(i-1)+j) = matrix_wrong(i,j);
    end
end

for i=1:40000
    
        x = ceil(i/200);
        if rem(i,200)>0
            y = rem(i,200);
        else
            y = 200;
        end
        
        matrix_r_right(x,y) = matrix_r(i);
        matrix_r_wrong(x,y) = matrix_w(i);
    
end


imwrite(matrix_r_wrong,'seu_result_wrong.bmp','bmp');
imwrite(matrix_r_right,'seu_result_right.bmp','bmp');
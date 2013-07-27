%hashreplaceme的子函数用以将MD5码转成数字
function result=md52num(md5code)
result=0;
for i=1:32
    result=result+table(md5code(i))*i;
end

end

% hashreplacement 的子函数用以查表转换16 进制字符为数字
function a = table(character)

switch character
    case '0' 
        a = 0; 
    case '1' 
        a = 1; 
    case '2 '
        a = 2; 
    case '3' 
        a = 3; 
    case '4' 
        a = 4;
    case '5' 
        a = 5; 
    case '6' 
        a = 6; 
    case '7' 
        a = 7; 
    case '8' 
        a = 8; 
    case '9' 
        a = 9;
    case 'a' 
        a = 10; 
    case 'b' 
        a = 11; 
    case 'c' 
        a = 12; 
    case 'd' 
        a = 13;
    case 'e' 
        a = 14; 
    otherwise
        a = 15;
end
end
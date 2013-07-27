function y = rsc_encode(g, x, terminated)
% Copyright Nov. 1998 Yufei Wu
% MPRG lab, Virginia Tech.
% for academic use only

% encodes a block of data x (0/1)with a recursive systematic
% convolutional code with generator vectors in g, and
% returns the output in y (0/1).
% if terminated>0, the trellis is perfectly terminated
% if terminated<0, it is left unterminated;

% determine the constraint length (K), memory (m), and rate (1/n)
% and number of information bits.
[n,K] = size(g);
m = K - 1;
if terminated>0
  L_info = length(x);
  L_total = L_info + m;
else
  L_total = length(x);
  L_info = L_total - m;
end  


% initialize the state vector
state = zeros(1,m);

% generate the codeword
for i = 1:L_total
   if terminated<0 || (terminated>0 && i<=L_info)
      d_k = x(1,i);
   elseif terminated>0 && i>L_info
      % terminate the trellis
      d_k = rem( g(1,2:K)*state', 2 );
   end
 
   a_k = rem( g(1,:)*[d_k state]', 2 );
   [output_bits, state] = encode_bit(g, a_k, state);
   % since systematic, first output is input bit
   output_bits(1) = d_k;%,1
   y(n*(i-1)+1:n*i) = output_bits;
end

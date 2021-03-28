clc; clear all; close all;
format long ;


nshift = 17;

N = 2^14;

n = 0:N-1;

z = exp(i*(n/N)*2*pi);

c = floor(2^(nshift).*imag(z))-1;

re = floor(2^(nshift).*real(z))-1;

fcos = fopen( 'real.txt', 'wt' );
fsin = fopen( 'imaginary.txt', 'wt' );

for ii = 1:N
    
if c(ii) < 0
fprintf(fsin, '%i%s\n',1, dec2bin(abs(c(ii)),nshift));
else   
fprintf(fsin, '%i%s\n',0, dec2bin(abs(c(ii)),nshift));
end
if re(ii) < 0
fprintf(fcos, '%i%s\n',1, dec2bin(abs(re(ii)),nshift));
else   
fprintf(fcos, '%i%s\n',0, dec2bin(abs(re(ii)),nshift));
end
end
fclose(fcos);
fclose(fsin);

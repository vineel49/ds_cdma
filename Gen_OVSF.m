% Generate orthogonal variable spread factor codes
% written by Vineel Kumar Veludandi
function [codes] = Gen_OVSF(level)
% Level 1
codes(1,:) = [1 1];
codes(2,:) = [1 -1];

% from Level 2 onwards
for i1 = 2:level
temp = codes;
codes = zeros(2^i1,2^i1);
for i2 = 1:2^(i1-1)    
codes(2*i2-1,:) = [temp(i2,:) temp(i2,:)];    
codes(2*i2,:) = [temp(i2,:) -1*temp(i2,:)];   
end
end

end

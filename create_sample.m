%Spring 2019, Sam Shapiro

function [sample, p_actual] = create_sample(m,n,p) %For my project with Nina
    %m-by-n image sample, with filling probability p (decimal)
    %'sample' is the generated pixel image. 
    %'p_actual' compares the number of white and black pixels, and gives an
    %accurate filling fraction.
for i = 1:m
    for j = 1:n
        
        x = rand;
        if x < p 
           sample(i,j) = 0;
        else
           sample(i,j) = 1;
        end
    end
end

%Find the p_actual (ratio of white to black pixels in the generated image)
n_activated = length(find(sample==0));
p_actual = n_activated/(m*n);

end
%Values of critical p: 0.592 for only nearest neighbors, 0.407 including
%next nearest neighbors. 

%1 corrisponds to a white pixel, 0 corrisponds to a black pixel

%We call the black pixels "activated"; these are the sites where
%superconducting material will be deposited

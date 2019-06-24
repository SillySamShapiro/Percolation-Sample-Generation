%Spring 2019, Sam Shapiro

function [sample, p_actual, sample_initial, comparison] = create_sample_weighted(m,n,p_i,p_0,c,distribution)
%mxn is the grid size. 
%Start out with non-weighted version, with small initial p (p_i), p_0 is
%probability for neighbor of distance 1 from a previously activated pixel to be activated, 
%c is for exponential weights
%distribution = 'exponential' or 'gaussian' defaults to gaussian. 'exponential'
%uses an exponential with a power that is linear in distance.

%I usually set p_i = 0.05, p_0 = 0.5 to 1.0, c = 1.0 and up 

%'Sample' is the final "clustered" image. 'p_actual' compares the number of
%black pixels to white and gives the actual p value of the sample.
%'sample_initial' is the initial image. 'compaison' shows both 'sample' and
%'sample_initial' in one picture, just for easy human comparison. 


sample_initial = zeros(m,n);

for i = 1:m
    for j = 1:n
        
        x = rand;
        if x < p_i 
           sample_initial(i,j) = 0;
        else
           sample_initial(i,j) = 1;
        end
    end
end

%find coordinates of activated and deactivated pixels
[row_a,col_a] = find(sample_initial == 0);
active_coords = [row_a,col_a];
[row_d,col_d ]= find(sample_initial == 1);
deactive_coords = [row_d,col_d];

%k nearest neighbor search
[~,distance] = knnsearch(active_coords, deactive_coords);

%Exponentially weighted probabilities for deactivated pixels
if distribution == "exponential"
    p = p_0*exp(c*(1-distance));
else
   p = p_0*exp(-c*(1-distance).^2);
end

prob = [deactive_coords, distance, p]; %An array of coords with deactivated pixels and the distance from their next nearest neighbor

%Fill in deactivated pixels according to probabilities p
sample = sample_initial;
len = length(prob);

for j = 1:len
    
    x = rand;
    if x < prob(j,4)
        sample(prob(j,1),prob(j,2)) = 0;
    else 
        sample(prob(j,1),prob(j,2)) = 1;
    end

end

%find p_actual (ratio of white to black pixels in final image)
n_activated = length(find(sample==0));
p_actual = n_activated/(m*n);

%Create an image that is the original image and the final image next to
%eachother (for easy visual comparison)
divider = 0.5*ones(m,ceil(m/50)); %gray bar to seperate images
comparison = horzcat(sample_initial, divider, sample);


end

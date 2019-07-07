%5/9/19 Sam Shapiro

function [new_img, p_new, comparison] = iterate_clusters(img, p_0, c, distribution)
%This function is a companion to create_sample_weighted.m. If you already
%have one of these pixelated images, and want to use it as a seed to expand
%from (like in the above function) this will do that. Much of the code
%below is adapted from that function.

%distribution = 'exponential' or 'gaussian' defaults to gaussian. 'exponential'
%uses an exponential with a power that is linear in distance.


%find coordinates of activated and deactivated pixels
[row_a,col_a] = find(img == 1);
active_coords = [row_a,col_a];
[row_d,col_d ]= find(img == 0);
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
new_img = img;
len = length(prob);

for j = 1:len
    
    x = rand;
    if x < prob(j,4)
        new_img(prob(j,1),prob(j,2)) = 1;
    else 
        new_img(prob(j,1),prob(j,2)) = 0;
    end

end

%find p_new (ratio of white to black pixels in final image)
n_activated = length(find(new_img==1));
p_new = n_activated/(numel(new_img));

%Create an image that is the original image and the final image next to
%eachother (for easy visual comparison)
divider = 0.5*ones(size(img,2),ceil(size(img,2)/50)); %gray bar to seperate images
comparison = horzcat(img, divider, new_img);

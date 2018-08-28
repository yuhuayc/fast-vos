function image = pre_processing( image )
%% pre_process performs preprocessing of input images of caffe
%
% yuhua chen <yuhua.chen@vision.ee.ethz.ch> 
% created on 2017.08.16
 
% perchannel mean across training data
mean_color = [104.00698793,116.66876762,122.67891434];

% switch to BGR
image = image(:,:,[3,2,1]);

% convert to single precision
image = single(image);

% substract mean color
image(:,:,1) = image(:,:,1) - mean_color(1);
image(:,:,2) = image(:,:,2) - mean_color(2);
image(:,:,3) = image(:,:,3) - mean_color(3);

% image(image<0) = 0;

% rearrange image dimension for Caffe(H x W x C)
image = permute(image, [2,1,3]);

end


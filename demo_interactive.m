%% Demo for interactive video segmentation
% yuhua chen <yuhua.chen@vision.ee.ethz.ch>

%% configs
addpath caffe/matlab
addpath utils

im_path = 'data/demo_data/horsejump-high';
cache_dir = 'data/cache';

zoom_ratio = 4;
opaque_ratio = 0.5;

net_prototxt = 'models/interactive/deploy.prototxt';
net_weight = 'models/interactive/test.caffemodel';
gpu_id = 1;

%% compute the embedding vectors
caffe.reset_all();
caffe.set_mode_gpu();
caffe.set_device(gpu_id);
net = caffe.Net(net_prototxt,net_weight,'test');

mkdir(cache_dir);
im_names = dir(fullfile(im_path,'*.jpg'));
im_names = {im_names.name}; im_names = cellfun(@(x) strrep(x,'.jpg',''),im_names,'UniformOutput',false);

for i_im = 1:numel(im_names)
    img = imread(fullfile(im_path,[im_names{i_im} '.jpg']));
    img_resize = imresize(img,[478 958]);
    img_pp = pre_processing(img_resize); net_input = img_pp;
    net.blobs(net.inputs{1}).reshape([size(net_input) 1]);
    net.blobs(net.inputs{1}).set_data(net_input);
    net.forward_prefilled();
    net_output = net.blobs(net.outputs{1}).get_data();
    net_output = permute(net_output,[2,1,3]);
    
    save((fullfile(cache_dir,[im_names{i_im} '.mat'])),'net_output');
end

%% load embedding vectors of a subset of images
all_img = cell(4,4);
all_feat = cell(4,4);
for i_im = 1:16
    frame_id = round(i_im*numel(im_names)/16);
    im_name = im_names{frame_id};
    load((fullfile(cache_dir,[im_name '.mat'])),'net_output');
    img = imread(fullfile(im_path,[im_name '.jpg']));
    img = imresize(img,zoom_ratio*size(net_output(:,:,1)));
    
    all_img{i_im} = img;
    all_feat{i_im} = net_output;
end
all_img = all_img'; all_feat = all_feat';

all_img = cell2mat(all_img);
all_feat = cell2mat(all_feat);
all_feat = reshape(all_feat,numel(all_feat(:,:,1)),[]);

%% interaction with users

D_max = zeros(size(all_feat,1),1);
lb_arr = ones(size(all_feat,1),1);
plot_img = uint8((1-opaque_ratio)*all_img);
obj_id = 1;
indx_col = [];
point_lb_col = [];
color_mask = zeros(size(all_img(:,:,1)));
close all

fprintf('\n\n Manual:\n left click: select object\n right click: select background\n z:undo \n r:clear\n numbers:switch object id (for multiple objects)\n Have fun!:)\n\n')
while(1)
    imshow(plot_img); hold on;
    [x,y,button] = ginput(1);
    
    if(isequal(button,1))
        point_lb = obj_id;
    elseif(isequal(button,3))
        point_lb = 0;
    elseif(isequal(button,122)) % z: undo
        D_max = D_max_prev;
        lb_arr = lb_arr_prev;
        color_mask = color_mask_prev;
        indx_col = indx_col_prev;
        point_lb_col = point_lb_col_prev;
        plot_img = uint8((1-opaque_ratio)*all_img + 2*opaque_ratio*uint8(color_mask));
        continue;
    elseif(isequal(button,114)) % r: clear all clicks
        D_max = zeros(size(all_feat,1),1);
        lb_arr = ones(size(all_feat,1),1);
        plot_img = uint8((1-opaque_ratio)*all_img);
        obj_id = 1;
        indx_col = [];
        point_lb_col = [];
        color_mask = zeros(size(all_img(:,:,1)));
        continue;
    else
        obj_id = button - 48;
        continue;
    end
    
    D_max_prev = D_max;
    color_mask_prev = color_mask;
    indx_col_prev = indx_col;
    point_lb_col_prev = point_lb_col;
    lb_arr_prev = lb_arr;
    
    x = round(x/zoom_ratio); y = round(y/zoom_ratio);
    indx = size(plot_img,1)/zoom_ratio*(x-1) + y;
    
    indx_col = [indx_col;indx];
    point_lb_col = [point_lb_col;point_lb];
    
    D = (1-pdist2(all_feat(:,1:(end-3)),all_feat(indx,1:(end-3)),'cosine'));
    [D_max,max_id] = max([D_max,D],[],2);
    lb_arr(max_id==2) = point_lb;
    
    mask = reshape(lb_arr,size(all_img,1)/zoom_ratio,size(all_img,2)/zoom_ratio);
    
    mask = imresize(mask,zoom_ratio,'nearest');
    color_mask = vis_color(mask,0);
    
    plot_img = uint8((1-opaque_ratio)*all_img + 2*opaque_ratio*uint8(color_mask));
end
function vis_map = vis_color(seg_map,show_switch) % visualize a superpixel map

cmap = uint8(vis.gen_color(21)*255);


vis_map = zeros([size(seg_map),3]);
vis_map_r = zeros(size(seg_map));
vis_map_g = zeros(size(seg_map));
vis_map_b = zeros(size(seg_map));

vis_map_r = reshape(cmap(seg_map+1,1),size(vis_map_r));
vis_map_g = reshape(cmap(seg_map+1,2),size(vis_map_g));
vis_map_b = reshape(cmap(seg_map+1,3),size(vis_map_b));

vis_map(:,:,1) = vis_map_r;
vis_map(:,:,2) = vis_map_g;
vis_map(:,:,3) = vis_map_b;

if(show_switch)
    imshow(vis_map);
end
end
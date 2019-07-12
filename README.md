# Blazingly Fast Video Object Segmentation with Pixel-Wise Metric Learning

This is a demo of our work 'Blazingly Fast Video Object Segmentation with Pixel-Wise Metric Learning', presented at CVPR 2018. The work aims to learn a pixel-wise embedding, where similar pixels are close in the embedding space, for video object segmentation. More details can be found in the [paper](https://arxiv.org/pdf/1804.03131.pdf).

If you find it helpful for your research, please consider citing the paper:

	@inproceedings{chen2018blazingly,
	  title={Blazingly Fast Video Object Segmentation with Pixel-Wise Metric Learning},
	  author={Chen, Yuhua and Pont-Tuset, Jordi and Montes, Alberto and Van Gool, Luc},
	  booktitle = {Computer Vision and Pattern Recognition (CVPR)},
	  year={2018}
	}

If you encounter any problem, feel free to contact me at yuhua[dot]chen[at]vision[dot]ee[dot]ethz[dot]ch.

### Installation
1. Clone the repo. 
    ```Shell
    git clone https://github.com/yuhuayc/fast-vos.git

2. The implementation is based on the Caffe version from PSPNet. Clone the repo, and build Caffe and matcaffe (see: [Caffe installation instructions](http://caffe.berkeleyvision.org/installation.html))
    ```Shell
    git clone https://github.com/hszhao/PSPNet.git
    make -j8 && make matcaffe

3. Create a soft link of Caffe in the project folder.
    ```Shell
    cd $VOS_ROOT/
    ln -s $CAFFE_ROOT caffe
    
### Interactive Video Segmentation Demo
1. An example script is provided in 'demo_interactive.m'.

2. Pre-trained model can be downloaded at [here](https://www.dropbox.com/s/9n3l6ib297idkvd/test.caffemodel?dl=0), move it to $VOS_ROOT/models/interactive/


### [Paper](https://arxiv.org/abs/2005.10821) | [YouTube](https://youtu.be/odAGA7pFBGA)  | [Cityscapes Score](https://www.cityscapes-dataset.com/method-details/?submissionID=7836) <br>

Pytorch implementation of our paper [Hierarchical Multi-Scale Attention for Semantic Segmentation](https://arxiv.org/abs/2005.10821).<br>

Please refer to the `sdcnet` branch if you are looking for the code corresponding to [Improving Semantic Segmentation via Video Prediction and Label Relaxation](https://nv-adlr.github.io/publication/2018-Segmentation).

## Slrum Files

`'.s'` files are `SBATCH` files used to allocate resources and run the commands in it. Since, the project is done in [NYU Greene](https://www.nyu.edu/research/navigating-research-technology/nyu-greene.html). We used [Singularity](https://sylabs.io/singularity/) to emulate virtual environment and run the script.   

### Output Results

`slurm-5851472.out` is the output of model eval, which is 61.08, same of the results of the paper.

`slurm-6791219.out` is the output of the model training using the whole dataset, which as expected gave CUDA out of memory error.

`slurm-6817264.out` is the output of model training using 30% of dataset run for 44 epoch for 60hrs and produced an IOU of 46.04. This rose from 20 to 46 in 44 epochs. The paper originally trained the whole dataset for 175 epochs, so can conclude that this is definately achievable with enough computational power and time.


### Resourses

For [eval](https://github.com/SaiKiranCVN/semantic-segmentation/blob/main/run-test.s) - 4 RTX 8000, 64GB RAM, ran for 2hrs.

For [Training](https://github.com/SaiKiranCVN/semantic-segmentation/blob/main/run-train.s) - 2 RTX 8000, 64GB RAM for 60hrs (30% of dataset).


## Installation 

* The code is tested with pytorch 1.3 and python 3.6


## Download Weights

* Create a directory where you can keep large files. Ideally, not in this directory.
```bash
  > mkdir <large_asset_dir>
```

* Update `__C.ASSETS_PATH` in `config.py` to point at that directory

  __C.ASSETS_PATH=<large_asset_dir>

* Download pretrained weights from [google drive](https://drive.google.com/open?id=1fs-uLzXvmsISbS635eRZCc5uzQdBIZ_U) and put into `<large_asset_dir>/seg_weights`

## Download/Prepare Data

Mapillary, download Mapillary data, then update `config.py` to set the path:
```python
__C.DATASET.MAPILLARY_DIR=<path_to_mapillary>
```


## Running the code

The instructions below make use of a tool called `runx`, which we find useful to help automate experiment running and summarization. For more information about this tool, please see [runx](https://github.com/NVIDIA/runx).
In general, you can either use the runx-style commandlines shown below. Or you can call `python train.py <args ...>` directly if you like.


### Run inference on Cityscapes

Dry run:
```bash
> python -m runx.runx scripts/eval_cityscapes.yml -i -n
```
This will just print out the command but not run. It's a good way to inspect the commandline. 

Real run:
```bash
> python -m runx.runx scripts/eval_cityscapes.yml -i
```

The reported IOU should be 86.92. This evaluates with scales of 0.5, 1.0. and 2.0. You will find evaluation results in ./logs/eval_cityscapes/...

### Run inference on Mapillary

```bash
> python -m runx.runx scripts/eval_mapillary.yml -i
```

The reported IOU should be 61.05. Note that this must be run on a 32GB node and the use of 'O3' mode for amp is critical in order to avoid GPU out of memory. Results in logs/eval_mapillary/...


## Train a model

Train cityscapes, using HRNet + OCR + multi-scale attention with fine data and mapillary-pretrained model
```bash
> python -m runx.runx scripts/train_cityscapes.yml -i
```

The first time this command is run, a centroid file has to be built for the dataset. It'll take about 10 minutes(took 1hr with 2 GPUs). The centroid file is used during training to know how to sample from the dataset in a class-uniform way.

This training run should deliver a model that achieves 84.7 IOU(46 with 30% data and only 44 epochs).

## Creating Jobs

Once we run the python with yml files, we will create `submit_cmd.sh` and `train_cmd.sh` which then can run using `SBATCH` by submitting the jobs.

```bash
> sbatch submit_cmd.sh # eval
> sbatch train_cmd.sh # Training
```

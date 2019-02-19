#!/bin/bash

rtabmap-kitti_dataset \
  --calibrationName=KITTI_07 \
  --type=1\
  --stereo\driver=2 \
  --StereoImages\path_left=~/Documents/RTAB-Map/KITTI/dataset/sequences/07/image_0 \
  --StereoImages\path_right=~/Documents/RTAB-Map/KITTI/dataset/sequences/07/image_1 \
  --stereo\depthGenerated=false \
  --Images\stamps=~/Documents/RTAB-Map/KITTI/dataset/sequences/07/times.txt \
  --Images\gt_path=~/Documents/RTAB-Map/KITTI/dataset/odometry_ground_truth/07.txt \
  --Images\gt_format=2 \
  --Rtabmap\CreateIntermediateNodes=true \
  --Rtabmap\ImageBufferSize=0 \
  --Odom\Strategy=1 \
  --Odom\ImageBufferSize=0 \
  --GFTT\MinDistance=10 \
  --GFTT\QualityLevel=0.002 \
  --Icp\CorrespondenceRatio=0.1 \
  --Icp\Iterations=10 \
  --Icp\MaxCorrespondenceDistance=0.3 \
  --Icp\MaxTranslation=0 \
  --Icp\PointToPlane=true \
  --Icp\VoxelSize=0 \
  --Icp\Epsilon=0.01 \
  --Reg\Strategy=0 \
  --Vis\EstimationType=1 \
  --Vis\PnPFlags=0 \
  --Vis\PnPReprojError=1 \
  --Vis\CorFlowWinSize=15 \
  --Vis\CorType=1 \
  ~/Documents/RTAB-Map/KITTI/dataset/sequences/07

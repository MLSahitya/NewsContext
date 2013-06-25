#Looping the k-means clustering with canopy for different threshold values to identify the their values for better clusters
MAHOUT_PATH="/home/newscontext/mahout" 
PROJECT_PATH="/home/newscontext/rails_projects/articles"

# using canopy to identify the initial centroids of the clusters
$MAHOUT_PATH/bin/mahout  canopy -i $PROJECT_PATH/clus/files-sparse/tfidf-vectors/ -o $PROJECT_PATH/clus/initial-clusters -t1 $1 -t2 $2  -dm org.apache.mahout.common.distance.EuclideanDistanceMeasure -ow

#kmeans clustering
$MAHOUT_PATH/bin/mahout kmeans -i $PROJECT_PATH/clus/files-sparse/tfidf-vectors/ -c $PROJECT_PATH/clus/initial-clusters/clusters-*-final -o $PROJECT_PATH/clus/kmeans -dm  org.apache.mahout.common.distance.TanimotoDistanceMeasure -cd 0.1 -x 15 -ow -cl -xm sequential

#getting the evaluation
$MAHOUT_PATH/bin/mahout clusterdump -s $PROJECT_PATH/clus/kmeans/clusters-*-final -o $PROJECT_PATH/clus/clusterdump$1 --evaluate -dm org.apache.mahout.common.distance.CosineDistanceMeasure -b 50 --pointsDir $PROJECT_PATH/clus/kmeans/clusteredPoints

#grep 'CDbw' /home/newscontext/mahout/examples/bin/clus/clusterdump$1 > /home/newscontext/mahout/examples/bin/clus/$1
#rm /home/newscontext/mahout/examples/bin/clus/clusterdump$1


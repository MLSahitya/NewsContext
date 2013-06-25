#forming sequence files from the files 
#/home/newscontext/mahout/bin/mahout seqdirectory -i /home/newscontext/rails_projects/articles/files/ -o /home/newscontext/mahout/examples/bin/clusters/files-seqdir1 -ow

#making sparse vectors
#/home/newscontext/mahout/bin/mahout seq2sparse -i /home/newscontext/mahout/examples/bin/clusters/files-seqdir1/ -o /home/newscontext/mahout/examples/bin/clusters/files-sparse1 -wt TFIDF --maxDFPercent 85 --namedVector -ow 

MAHOUT_PATH="/home/newscontext/mahout" 
PROJECT_PATH="/home/newscontext/rails_projects/articles"
  
# using canopy to identify the initial centroids of the clusters
$MAHOUT_PATH/bin/mahout  canopy -i $PROJECT_PATH/clus/files-sparse/tfidf-vectors/ -o $PROJECT_PATH/clus/initial-clusters -t1 $1 -t2 $2  -dm org.apache.mahout.common.distance.EuclideanDistanceMeasure -ow 

#Kmeans clustering
$MAHOUT_PATH/bin/mahout kmeans -i $PROJECT_PATH/clus/files-sparse/tfidf-vectors/ -c $PROJECT_PATH/clus/initial-clusters/clusters-*-final -o $PROJECT_PATH/clus/kmeans -dm  org.apache.mahout.common.distance.TanimotoDistanceMeasure -cd 0.1 -x 15 -ow -cl -xm sequential #Tanimoto

#obtaining the clustering output in understandable format
$MAHOUT_PATH/bin/mahout clusterdump -s $PROJECT_PATH/clus/kmeans/clusters-*-final -o $PROJECT_PATH/app/assets/clusterdump -d $PROJECT_PATH/clus/files-sparse/dictionary.file-0 -dt sequencefile -n 15 --evaluate -dm org.apache.mahout.common.distance.CosineDistanceMeasure -b 50 --pointsDir $PROJECT_PATH/clus/kmeans/clusteredPoints

#getting the mapping of the files and their clusters
$MAHOUT_PATH/bin/mahout seqdumper -s $PROJECT_PATH/clus/kmeans/clusteredPoints/part-m-* > $PROJECT_PATH/app/assets/cluster-points.txt

# using canopy to identify the initial centroids of the clusters
/home/newscontext/mahout/bin/mahout  canopy -i /home/newscontext/mahout/examples/bin/clus/files-sparse1/tfidf-vectors/ -o /home/newscontext/mahout/examples/bin/clus/initial-clusters1 -t1 $1 -t2 $2  -dm org.apache.mahout.common.distance.EuclideanDistanceMeasure -ow 
#kmeans clustering
/home/newscontext/mahout/bin/mahout kmeans -i /home/newscontext/mahout/examples/bin/clus/files-sparse1/tfidf-vectors/ -c /home/newscontext/mahout/examples/bin/clus/initial-clusters1/clusters-*-final -o /home/newscontext/mahout/examples/bin/clus/kmeans1 -dm  org.apache.mahout.common.distance.TanimotoDistanceMeasure -cd 0.1 -x 15 -ow -cl -xm sequential #Tanimoto
#getting the evaluation
/home/newscontext/mahout/bin/mahout clusterdump -s /home/newscontext/mahout/examples/bin/clus/kmeans1/clusters-*-final -o /home/newscontext/mahout/examples/bin/clus/clusterdump$1 --evaluate -dm org.apache.mahout.common.distance.CosineDistanceMeasure -b 50 --pointsDir /home/newscontext/mahout/examples/bin/clus/kmeans1/clusteredPoints

grep 'CDbw' /home/newscontext/mahout/examples/bin/clus/clusterdump$1 > /home/newscontext/mahout/examples/bin/clus/$1
rm /home/newscontext/mahout/examples/bin/clus/clusterdump$1


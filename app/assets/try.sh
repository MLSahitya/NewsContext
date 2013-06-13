#forming sequence files from the files 
#/home/newscontext/mahout/bin/mahout seqdirectory -i /home/newscontext/rails_projects/articles/files/ -o /home/newscontext/mahout/examples/bin/clusters/files-seqdir1 -ow

#making sparse vectors
#/home/newscontext/mahout/bin/mahout seq2sparse -i /home/newscontext/mahout/examples/bin/clusters/files-seqdir1/ -o /home/newscontext/mahout/examples/bin/clusters/files-sparse1 -wt TFIDF --maxDFPercent 85 --namedVector -ow 

# using canopy to identify the initial centroids of the clusters
/home/newscontext/mahout/bin/mahout  canopy -i /home/newscontext/mahout/examples/bin/clus/files-sparse1/tfidf-vectors/ -o /home/newscontext/mahout/examples/bin/clus/initial-clusters1 -t1 $1 -t2 $2  -dm org.apache.mahout.common.distance.EuclideanDistanceMeasure -ow 

#Kmeans clustering
/home/newscontext/mahout/bin/mahout kmeans -i /home/newscontext/mahout/examples/bin/clus/files-sparse1/tfidf-vectors/ -c /home/newscontext/mahout/examples/bin/clus/initial-clusters1/clusters-*-final -o /home/newscontext/mahout/examples/bin/clus/kmeans1 -dm  org.apache.mahout.common.distance.TanimotoDistanceMeasure -cd 0.1 -x 15 -ow -cl -xm sequential #Tanimoto

#obtaining the clustering output in understandable format
/home/newscontext/mahout/bin/mahout clusterdump -s /home/newscontext/mahout/examples/bin/clus/kmeans1/clusters-*-final -o /home/newscontext/rails_projects/articles/app/assets/clusterdump -d /home/newscontext/mahout/examples/bin/clus/files-sparse1/dictionary.file-0 -dt sequencefile -n 15 --evaluate -dm org.apache.mahout.common.distance.CosineDistanceMeasure -b 50 --pointsDir /home/newscontext/mahout/examples/bin/clus/kmeans1/clusteredPoints


/home/newscontext/mahout/bin/mahout seqdumper -s /home/newscontext/mahout/examples/bin/clus/kmeans1/clusteredPoints/part-m-* > /home/newscontext/rails_projects/articles/app/assets/cluster-points.txt


#for x in `ls /home/newscontext/mahout/examples/bin/cluster/output $1`; do
#echo
#ruby /home/newscontext/mahout/examples/bin/cluster/output/$x/files >  /home/newscontext/mahout/examples/bin/cluster/output/$x/output.txt
#done


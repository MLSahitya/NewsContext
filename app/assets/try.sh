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

#moving the outputs to rails application
#cp /home/newscontext/mahout/examples/bin/clus/cluster-points.txt /home/newscontext/rails_projects/articles/app/assets/cluster-points.txt
#cp /home/newscontext/mahout/examples/bin/clusters/clusterdump$1 /home/newscontext/rails_projects/articles/app/assets/clusterdump
#grep -n '{n=' /home/newscontext/mahout/examples/bin/clusters/clusterdump > /home/newscontext/mahout/examples/bin/clusters/result.txt

#mkdir /home/newscontext/mahout/examples/bin/cluster/output
#/usr/bin/env ruby <<-EORUBY
#puts "running ruby"
#File.open("/home/newscontext/mahout/examples/bin/cluster/clusterdump") do |f|
#while line = f.gets  
     
 #    if (line.include? "c=[")
  #       i=line.index(":")
 #        j=line.index("{")
 #        clustername = line[i+1,j-1]
 #        #puts clustername
 #        i=line.index("=")
 #        j=line.index(" ")
 #        clustersize = line[i+1,j-i-1]
 #        #puts clustersize
 #        %x[mkdir /home/newscontext/mahout/examples/bin/cluster/output/"#{clustername}" ]
 #        path ="/home/newscontext/mahout/examples/bin/cluster/output/" + clustername +"/files"
#         file=File.new(path,"a+")
#         #file.write(clustersize + "\n")
#	 file.close 
#     elsif (line.include? "distance=")
#         i=line.index("/")
#         filename=line[i+1,30]
#         j=filename.index(" ")
#         filename=filename[0,j]
#         file=File.new(path,"a+")
#         file.write("puts \""+filename+"\"\n puts %x[cat /home/newscontext/rails_projects/articles/bfiles/"+filename + "]\n")
#	 file.close
#     end

#  end  
#end  
#EORUBY

#for x in `ls /home/newscontext/mahout/examples/bin/cluster/output $1`; do
#echo
#ruby /home/newscontext/mahout/examples/bin/cluster/output/$x/files >  /home/newscontext/mahout/examples/bin/cluster/output/$x/output.txt
#done


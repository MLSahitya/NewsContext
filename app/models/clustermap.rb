class Clustermap
  include Mongoid::Document
  field :name, type: String
  field :clusid, type: String

  def self.store_clustermap()  
    c =0
   #This is for only one level of clustering, if multiple levels are used get the outer cluster id for the Input path in the file ie #Input Path: examples/bin/stemming/kmeans1/clusteredPoints/part-m-0
   File.open("/home/newscontext/rails_projects/articles/app/assets/cluster-points65.txt") do |f|
   while line = f.gets  
          if (line.include? "Value:")
             c = c+ 1
	#Key: 11: Value: 1.0: /file1597 = [175 
	#this is the format of output file, we need Key(cluster): 11 and File: file1597
          j=line.index("V")
          i=line.index(" ")
          clustername = line[i+1,j-i-3]
	  
          j=line.index("=")
          i=line.index("/")
          filename = line[i+1,j-i-2]
          #store these values in the database
	  unless Clustermap.where(name: filename,clusid: clustername).exists?
          create!( 
            :name     => filename,  
            :clusid      => clustername  
          ) 
          end
         
         end

   end 
   end  
   puts c
  end

end

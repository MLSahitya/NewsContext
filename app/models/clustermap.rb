class Clustermap
PROJECT_PATH="/home/newscontext/rails_projects/articles"

  include Mongoid::Document
  field :name, type: String
  field :clusid, type: String

  # here we store the results of clustering into the database
  def self.store_clustermap()  
   	 c =0
   # read the cluster results obtained from mahout clustering
   File.open("#{PROJECT_PATH}/app/assets/cluster-points.txt") do |f| 
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
   
          #store these values into the database
	  unless Clustermap.where(name: filename,clusid: clustername).exists?
          create!( 
            :name     => filename,  
            :clusid      => clustername  
          ) 
          end # unless loop
          end # if loop
   end # while loop
   end  # file loop ending

  end # store_clustermap function close

end # class ending

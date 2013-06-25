require 'lingua/stemmer'
class ClusterController < ApplicationController
PROJECT_PATH="/home/newscontext/rails_projects/articles"

# this function takes parameters and generates files with processed articles data for clustering 
def stemming(type,words,date)
        # selecting feeds to be clustered
        @feeds= Feedentry.where(pubon: /#{date}/,summary: /#{words}/,type: /#{type}/)
        c = 0
        # process each feed data 
        @feeds.each do |feed| 
  	  summ=" "+feed.title.to_s()+" "+feed.summary.to_s()
	  summ = summ.downcase
          summ=summ.gsub /nbsp/,''
	  words = summ.scan(/\w+/)
            summ =''
          # remove too short words and numbers
          words.each do |key|
           if key.length > 3 && !key.match(/\d/)
            summ  = summ + " " + Lingua.stemmer(key, :language=>"en")
          end
          end
	  words = summ.scan(/\w+/)
          #considering only articles whose title and summary have more than 20 words
          if (words.length > 20)
          #path to store the text files for clustering in mahout.
          filename = "#{PROJECT_PATH}/files/" + feed.name
          f=File.new(filename,"w")
 	  f.write(summ)
	  f.close
          c = c + 1
          #puts "No of files created :" + c.to_s()
          end
        end 

end
  def clustervalue
   	l=20
        ml=20
	n=5
	int=40
	flag=0
	c=0
	value=0
	metrics=Array.new(6){Array.new(4)}
        prev=[20,60,100,140,180,220]
        new=prev
        nex=[]
	while int >=5
        if (int!=40)
           new=nex-prev
        end
	file=File.open("#{PROJECT_PATH}/f","w+")
	while c< new.length
	name= "sh #{PROJECT_PATH}/app/assets/automate.sh #{new[c]} #{new[c]+10}\n"
	file.write(name)
	c=c+1
	end
	file.close
	%x[sh /home/newscontext/rails_projects/articles/f]
	c=0
	while c<=n
	s=l+(c*int)
	if s >= ml
        name="#{PROJECT_PATH}/clus/clusterdump"+s.to_s()
	File.open(name) do |fl|
	  while line = fl.gets
	    metrics[c][0]=s.to_i()  
	    if (line.include? "CDbw Separation")
		i=line.index(":")
		j=line.index(".")
		metrics[c][1] = line[i+2,j-i+5].to_f()
	    elsif (line.include? "CDbw Inter-Cluster Density")
		i=line.index(":")
		j=line.index(".")
		metrics[c][2] = line[i+2,j-i+5].to_f()
	    elsif (line.include? "CDbw Intra-Cluster Density")
		i=line.index(":")
		j=line.index(".")
		metrics[c][3] = line[i+2,j-i+5].to_f()
	    end
	 end
	end
	end
	c=c+1	
	end
	linter=metrics[0][2]
	c=1
	while c<=n
	 if metrics[c][2]<linter && metrics[c][1] > 0.0
	  linter=metrics[c][2]
	 end
	c=c+1
	end
	msep=-1
	c=0
	while c<=n
	 if metrics[c][2]==linter && msep==-1 
	   msep=metrics[c][1]
	   value=metrics[c][0]
	 elsif metrics[c][2]==linter && msep < metrics[c][1]
	   value=metrics[c][0]
	 end
	c=c+1
	end
	l=value-int
	int=int/2
	c=0
        i=0
        prev=prev+new
        while c<=n
	s=l+(c*int)
	if s >= ml 
 	   nex[i]=s
        i=i+1
        end
	c=c+1
	end
  	c=0
	end
        return value
  end

  def home
   ## calling the clustering algorithm here
   ## Running kmeans clustering algorithm
   # clear previous data
   %x[rm -r /home/newscontext/rails_projects/articles/files]
   
   # create new directory to store processed article data
   %x[mkdir /home/newscontext/rails_projects/articles/files]
   
   # call the preprocessing of article data
   stemming(params[:type],params[:words],params[:date])
   
   ##forming sequence files from the files 
   %x[ /home/newscontext/mahout/bin/mahout seqdirectory -i /home/newscontext/rails_projects/articles/files -o /home/newscontext/rails_projects/articles/clus/files-seqdir -ow]
   
   ##making sparse vectors
   %x[ /home/newscontext/mahout/bin/mahout seq2sparse -i /home/newscontext/rails_projects/articles/clus/files-seqdir/ -o /home/newscontext/rails_projects/articles/clus/files-sparse -wt TFIDF --maxDFPercent 85 --namedVector -ow ]
   
   value=clustervalue #obtaining the canopy threshold values
   # clustering with the resulted canopy threshold values
   file=File.open("#{PROJECT_PATH}/f","w+")
   name= "sh #{PROJECT_PATH}/app/assets/try.sh #{value} #{value+10}\n"
   file.write(name)
   file.close
   %x[sh /home/newscontext/rails_projects/articles/f]
   %x[rm -r /home/newscontext/rails_projects/articles/clus/]
  end

  def store
   @clustermap=Clustermap.all
   @clustermap.destroy
   Clustermap.store_clustermap()
   @clustermap=Clustermap.distinct(:clusid)
   clusno=@clustermap.count
   # Take the output of clustering algorithm and display the clusters as groups
   # when u access individual finally reach the article page
   clusters=Array.new(clusno){Array.new(2)}
   stmt=""
   c =0
   File.open("#{PROJECT_PATH}/app/assets/clusterdump") do |f|
   while line = f.gets  

          if (line.include? " c=[")
          j=line.index("{")
          i=line.index("-")
	  if stmt!=""
  	     clusters[c][1]=stmt
             c = c + 1
             stmt=""
          end
          #puts c
	  clusters[c][0]=line[i+1,j-i-1]
	  elsif (line.include? "=>")
          words = line.scan(/\w+/)
	  #puts words[0]
          stmt =stmt +" "+ words[0]
	  end
   end
   clusters[c][1]=stmt
   end   
   puts clusters
   @clusters=clusters

  end

  def display
   @clusEle= Clustermap.where(clusid: params[:id])
   i=@clusEle.count
   #puts i
   feeds=Array.new(i)
   j=0
   @clusEle.each do |c|
      feeds[j]=c.name
       j=j+ 1
   end
   puts feeds.count
   @feedentries=Feedentry.where(name: feeds[0]) 
   
   j=1
   while j<=i
      @feedentries=@feedentries +Feedentry.where(name: feeds[j]) 
     j=j+1
   end  
   @names = feeds
  end
end


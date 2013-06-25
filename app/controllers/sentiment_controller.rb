class SentimentController < ApplicationController
PROJECT_PATH="/home/newscontext/rails_projects/articles"


  def calculate
     #creating the hash for positive and negative words
     sentimenthash=Hash.new
     metrics=Array.new(145){Array.new(2)}
     result=Array.new(80){Array.new(2)}
   
     # store word ratings into sentimenthash for later use
     #wordslist for general positive and negative woeds
     #ratedwords for sub specific +ve -ve words
     File.open("#{PROJECT_PATH}/assets/classification/ratedwords") do |f|
     while line=f.gets
      link= line.tr("\n",'')
      line=link
      i=line.index(" ")
      j=line.length
      sentiment=line[0,i].to_f()
      term=line[i+1,j-i]
      sentimenthash[term]=sentiment
     end
     end

     #do evaluation for each sentence
     art=""
     k=0
     filescore=0
     posscore=0
     negscore=0
     possscore=0
     negsscore=0
     pstmts=0
     nstmts=0
     nl=0
     notflag=0
     type=""
     # mention file whose sentiment needs to be analysed
     @name="9408"
	File.open("#{PROJECT_PATH}/assets/classification/files/"+@name) do |f|
     while line=f.gets
        notflag=0
        art=line 
        words=art.scan(/\w+/)
         # remove too short lines, they are mostly publication or author details
   	 if words.length >2
     	    nl=nl+1
   	    score=0
        notcount=0
        
     	words.each do |key|
        if !key.match(/\d/)&&key.length>2
            value=sentimenthash[key] # check if word is a sentiment word
            if notflag==1
               notcount+=1
            end
            if key=="not"
               notflag=1
               notcount=1
            end 
           if value!=nil
             if notflag==1 && notcount < 3
                value=value*-1 # changing the sentiment of a word if not is located atmost 3 words before the sentiment word
	     else 
 	     notflag=0
	     end
             score=score+value
             if value > 0
               posscore=posscore+value
             elsif value < 0
               negscore=negscore+value
  	     end
	     metrics[k][0]=key
             metrics[k][1]=value
             k=k+1
           end
        end
    	end     
     if notflag=1 
       # score=-1*score
     end
     # sentiment score of each sentence
     if score < 0
        negsscore +=score
        filescore -=1
        nstmts=nstmts+1
        type="NEGATIVE"
     elsif score > 0
       filescore +=1
        possscore +=score
        pstmts=pstmts+1
	type="POSITIVE"
     else
   	type="NEUTRAL"
     end
        
     result[nl][0]=line
     result[nl][1]=score
     end
     end
     end
     
     @words=k
     @result=filescore
     @numlines=nl
     @metric=metrics
     @stmts=result
     @pos=pstmts
     @neg=nstmts
     @posw=posscore
     @negw=negscore
     @poss=possscore
     @negs=negsscore
     
  end

  def display
     # this function should be used to show the sentiment but during the function was used to generate the files 
	@feeds= Feedentry.where(title: /.*Yahoo.*Tumblr.*/)
        c = 0
        @feeds.each do |feed| 
          filename = "/home/newscontext/rails_projects/articles/classification/paras/" + feed.name
          f=File.new(filename,"w")
  	  art=feed.article
          #cleaning the text files 
          #art=art.gsub /\n[ ]*\n/,"\n"
	  #art=art.gsub /\n[ ]*\n/,"\n"
	  # art=art.gsub /\. /,".\n"
	  #art=art.gsub /n’t/,"not"
	  #art=art.gsub /n't/,"not"
     	  #art=art.gsub /'/," "
     	  #art=art.gsub /’/," "
          #  art=art.gsub /\? /,"?\n"
	#  sentences=art.split(/\n/)
        #  sc=0
        #  while (sc<sentences.length)
        #  if(sentences[sc]==""||sentences[sc]==" ")
        #  else
	#  f.write(sentences[sc]+"\n")
        #  end
        #  sc=sc+1
 	#  end
 	f.write(art) 
        f.close
        c = c + 1
        puts "No of files created :" + c.to_s() 
        end 
  end
end

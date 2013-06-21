require 'lingua/stemmer'
class ClusterController < ApplicationController
def fulltext
  @feeds= Feedentry.where(pubon: /2013-02.*/)
        c = 0
        @feeds.each do |feed| 
          filename = "/home/newscontext/rails_projects/articles/docts/" + feed.name
          f=File.new(filename,"w")
  	  summ=" "+feed.title.to_s()+" "+feed.summary.to_s()
	  summ = summ.downcase
	  words = summ.scan(/\w+/)
          words - ["nbsp"]
    	  summ =''
          words.each do |key|
           if key.length > 3 && !key.match(/\d/)
            summ  = summ + ' ' + key
          end
          end
 	 #puts summ
          f.write(summ)
	  f.close
        c = c + 1
        puts "No of files created :" + c.to_s() 
        end 

end  
def stemming(type,words,date)
        #first create an empty folder files
        @feeds= Feedentry.where(pubon: /#{date}/,summary: /#{words}/,type: /#{type}/)
        c = 0
        @feeds.each do |feed| 
  	  summ=" "+feed.title.to_s()+" "+feed.summary.to_s()
	  summ = summ.downcase
          summ=summ.gsub /nbsp/,''
	  words = summ.scan(/\w+/)
            summ =''
          words.each do |key|
           if key.length > 3 && !key.match(/\d/)
            summ  = summ + " " + Lingua.stemmer(key, :language=>"en")
          end
          end
	  words = summ.scan(/\w+/)
          #considering only articles whose title and summary have more than 20 words
          if (words.length > 20)
          filename = "/home/newscontext/rails_projects/articles/bfiles/" + feed.name
          f=File.new(filename,"w")
 	  f.write(summ)
	  f.close
          c = c + 1
          #puts "No of files created :" + c.to_s()
          end
        end 

end
def stopstem
stopwords = ["a","able","nbsp","about","above","abst","accordance","according","accordingly","across","act","actually","added","adj",
"affected","affecting","affects","after","afterwards","again","against","ah","all","almost","alone","along","already","also",
"although","always","am","among","amongst","an","and","announce","another","any","anybody","anyhow","anymore","anyone",
"anything","anyway","anyways","anywhere","apparently","approximately","are","aren","arent","arise","around","as","aside",
"ask","asking","at","auth","available","away","awfully","b","back","be","became","because","become","becomes","becoming",
"been","before","beforehand","begin","beginning","beginnings","begins","behind","being","believe","below","beside","besides",
"between","beyond","biol","both","brief","briefly","but","by","c","ca","came","can","cannot","can't","cause","causes",
"certain","certainly","co","com","come","comes","contain","containing","contains","could","couldnt","d","date","did","didn't",
"different","do","does","doesn't","doing","done","don't","down","downwards","due","during","e","each","ed","edu","effect",
"eg","eight","eighty","either","else","elsewhere","end","ending","enough","especially","et","etal","etc","even","ever",
"every","everybody","everyone","everything","everywhere","ex","except","f","far","few","ff","fifth","first","five","fix",
"followed","following","follows","for","former","formerly","forth","found","four","from","further","furthermore","g","gave",
"get","gets","getting","give","given","gives","giving","go","goes","gone","got","gotten","h","had","happens","hardly","has",
"hasn't","have","haven't","having","he","hed","hence","her","here","hereafter","hereby","herein","heres","hereupon","hers",
"herself","hes","hi","hid","him","himself","his","hither","home","how","howbeit","however","hundred","i","id","ie","if",
"i'll","im","immediate","immediately","importance","important","in","inc","indeed","index","information","instead","into",
"invention","inward","is","isn't","it","itd","it'll","its","itself","i've","j","just","k","keep","keeps","kept","kg","km",
"know","known","knows","l","largely","last","lately","later","latter","latterly","least","less","lest","let","lets","like",
"liked","likely","line","little","'ll","look","looking","looks","ltd","m","made","mainly","make","makes","many","may","maybe",
"me","mean","means","meantime","meanwhile","merely","mg","might","million","miss","ml","more","moreover","most","mostly",
"mr","mrs","much","mug","must","my","myself","n","na","name","namely","nay","nd","near","nearly","necessarily","necessary",
"need","needs","neither","never","nevertheless","new","next","nine","ninety","no","nobody","non","none","nonetheless",
"noone","nor","normally","nos","not","noted","nothing","now","nowhere","o","obtain","obtained","obviously","of","off",
"often","oh","ok","okay","old","omitted","on","once","one","ones","only","onto","or","ord","other","others","otherwise",
"ought","our","ours","ourselves","out","outside","over","overall","owing","own","p","page","pages","part","particular",
"particularly","past","per","perhaps","placed","please","plus","poorly","possible","possibly","potentially","pp",
"predominantly","present","previously","primarily","probably","promptly","proud","provides","put","q","que","quickly",
"quite","qv","r","ran","rather","rd","re","readily","really","recent","recently","ref","refs","regarding","regardless",
"regards","related","relatively","research","respectively","resulted","resulting","results","right","run","s","said","same",
"saw","say","saying","says","sec""section","see","seeing","seem","seemed","seeming","seems","seen","self","selves","sent",
"seven","several","shall","she","shed","she'll","shes","should","shouldn't","show","showed","shown","showns","shows",
"significant","significantly","similar","similarly","since","six","slightly","so","some","somebody","somehow","someone",
"somethan","something","sometime","sometimes","somewhat","somewhere","soon","sorry","specifically","specified","specify",
"specifying","still","stop","strongly","sub","substantially","successfully","such","sufficiently","suggest","sup","sure","t",
"take","taken","taking","tell","tends","th","than","thank","thanks","thanx","that","that'll","thats","that've","the","their",
"theirs","them","themselves","then","thence","there","thereafter","thereby","thered","therefore","therein","there'll",
"thereof","therere","theres","thereto","thereupon","there've","these","they","theyd","they'll","theyre","they've","think",
"this","those","thou","though","thoughh","thousand","throug","through","throughout","thru","thus","til","tip","to","together",
"too","took","toward","towards","tried","tries","truly","try","trying","ts","twice","two","u","un","under","unfortunately",
"unless","unlike","unlikely","until","unto","up","upon","ups","us","use","used","useful","usefully","usefulness","uses",
"using","usually","v","value","various","'ve","very","via","viz","vol","vols","vs","w","want","wants","was","wasn't","way",
"we","wed","welcome","we'll","went","were","weren't","we've","what","whatever","what'll","whats","when","whence","whenever",
"where","whereafter","whereas","whereby","wherein","wheres","whereupon","wherever","whether","which","while","whim","whither",
"who","whod","whoever","whole","who'll","whom","whomever","whos","whose","why","widely","willing","wish","with","within",
"without","won't","words","world","would","wouldn't","www","x","y","yes","yet","you","youd","you'll","your","youre","yours",
"yourself","yourselves","you've","z","zero"]

  @feeds= Feedentry.where(pubon: /2013-02.*/)
        c = 0
        @feeds.each do |feed| 
          filename = "/home/newscontext/rails_projects/articles/sfiles/" + feed.name
          f=File.new(filename,"w")
  	  summ=" "+feed.title.to_s()+" "+feed.summary.to_s()
	  summ = summ.downcase
          summ=summ.gsub /nbsp/,''
	  words = summ.scan(/\w+/)
          words=words - stopwords
    	  summ =''
          words.each do |key|
           if !key.match(/\d/)
            summ  = summ + ' ' + Lingua.stemmer(key, :language=>"en")
          end
          end
 	 #puts summ
          f.write(summ)
	  f.close
        c = c + 1
       # puts "No of files created :" + c.to_s() 
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
	file=File.open("/home/newscontext/mahout/examples/bin/f","w+")
	while c< new.length
	name= "sh /home/newscontext/mahout/examples/bin/automate.sh #{new[c]} #{new[c]+10}\n"
	file.write(name)
	c=c+1
	end
	file.close
	%x[sh /home/newscontext/mahout/examples/bin/f]
	c=0
	while c<=n
	s=l+(c*int)
	if s >= ml
        name="/home/newscontext/mahout/examples/bin/clus/"+s.to_s()
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
   #used for during evaluation process
   #stemming
   #fulltext
   #stopstem
   ## calling the clustering algorithm here
   ## Running kmeans clustering algorithm
   %x[rm -r /home/newscontext/rails_projects/articles/files]
   %x[mkdir /home/newscontext/rails_projects/articles/files]
   stemming(params[:type],params[:words],params[:date])
   ##forming sequence files from the files 
   %x[ /home/newscontext/mahout/bin/mahout seqdirectory -i /home/newscontext/rails_projects/articles/files -o /home/newscontext/mahout/examples/bin/clus/files-seqdir1 -ow]
   ##making sparse vectors
   %x[ /home/newscontext/mahout/bin/mahout seq2sparse -i /home/newscontext/mahout/examples/bin/clus/files-seqdir1/ -o /home/newscontext/mahout/examples/bin/clus/files-sparse1 -wt TFIDF --maxDFPercent 85 --namedVector -ow ]
   value=clustervalue
   #puts value
   file=File.open("/home/newscontext/mahout/examples/bin/f","w+")
   name= "sh /home/newscontext/mahout/examples/bin/try.sh #{value} #{value+10}\n"
   file.write(name)
   file.close
   %x[sh /home/newscontext/mahout/examples/bin/f]
   %x[rm -r /home/newscontext/mahout/examples/bin/clus/]
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
   File.open("/home/newscontext/rails_projects/articles/app/assets/clusterdump65") do |f|
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


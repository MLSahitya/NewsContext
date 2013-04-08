require 'rubygems'
require 'open-uri'
require 'readability'
require 'lingua/stemmer'

class Feedentry

STOPWORDS = ["a","able","about","above","abst","accordance","according","accordingly","across","act","actually","added","adj",
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

  include Mongoid::Document
  field :name, type: String
  field :summary, type: String
  field :url, type: String
  field :pubon, type: String
  field :guid, type: String
  field :type, type: String
  field :article, type: String
  field :keywords, type: String

  def self.update_from_feed(feed_url,topic)
       feedcount = 0
       feed = Feedzirra::Feed.fetch_and_parse(feed_url) #parsing the rss feed
       begin    
         feed.entries.each do |entry|
 	  unless Feedentry.where(guid: entry.id, name: entry.title).exists? 
          
	  #reading the complete article 
	  #source = open(entry.id).read
           art=""
          #art = Readability::Document.new(source).content
          #art = art.gsub /\<.*?\>/,''
          summ=entry.summary
          summ=summ.gsub /\<.*?\>/,''
	  stmt = entry.title + ' ' + summ 
          stmt = stmt.downcase
	  words = stmt.scan(/\w+/)
    	  # stopwords removal from the obtained list of words from the title,summary, article
          keywords = words - STOPWORDS
	  #puts "------------------------------------------------------------------"
          # Steming of the words
          words = keywords
          keywords = []
          stmt =''
          words.each do |key|
           stmt  = stmt + ' ' + Lingua.stemmer(key, :language=>"en")
          end
          keywords =stmt.scan(/\w+/)
          #keywords = keywords.uniq
	  stmt = ''
          keywords.each do |key|
           stmt  = stmt + ' ' + key     
          end
          #puts "sahitya"
          create!(
          :name         => entry.title,
          :summary      => summ,
          :url          => entry.url,
          :pubon => entry.published,
          :guid         => entry.id,
          :type => topic,
          :article => art,  
          :keywords => stmt
          )


          #filename = "/home/newscontext/rails_projects/articles/TextFiles/"+entry.title
          #puts filename          
          #f=File.new(filename,"w")
	  #f.write(stmt)
	  #f.close  
          #puts "sahitya"
          end
 
          end
 
      # In case of error while parsing the rss feeds, main article 	
      rescue
  	f=File.open("/home/newscontext/rails_projects/articles/log/Log","a+")
	f.write(topic+":"+feed_url + "\n")
	f.close  
      end
      
  end
  
  def self.clean
     @feeds=Feedentry.all
     @feeds.each do  |feed| 
     stmt = feed.summary
     puts stmt
     stmt = stmt.gsub /\<.*?\>/,''
     Feedentry.find(feed._id).set(:summary,stmt)
     end
  end

  def self.storeArticle
	@feeds= Feedentry.all
        @feeds.each do |feed| 
         #reading the complete article 
          if feed.article=="" || feed.article==" "
	  begin
	  source = open(feed.url).read
          art = Readability::Document.new(source).content
          art = art.gsub /\<.*?\>/,''
          
          rescue
          art = " "
          end
          Feedentry.find(feed._id).set(:article, art)
          end
     end   
  end
   
    #obtain the keywords of each article stored
  def self.keywordsExtract
       # stopwordArray
	@feeds =Feedentry.all
        @feeds.each do |feed|
        art =''
          if feed.name == nil 
          	feed.name = " "
          end
          if feed.summary == nil 
		feed.summary = " "
	  end
          if feed.article == nil 
		feed.article = " "
 	  end
          art1 = feed.name + ' ' + feed.summary 
          art2 = feed.article
	  art1 =art1.downcase
	  art2 =art2.downcase
          #stmt = art.gsub /\<.*?\>/,''
          stmt = art1 + ' main_article_key ' + art2
          words = stmt.scan(/\w+/)
    	  # stopwords removal from the obtained list of words from the title,summary, article
          keywords = words - STOPWORDS
	  #puts "------------------------------------------------------------------"
          # Steming of the words
          words = keywords
          keywords = []
          stmt =''
          words.each do |key|
           stmt  = stmt + ' ' + Lingua.stemmer(key, :language=>"en")
          end
          keywords =stmt.scan(/\w+/)
          keywords = keywords.uniq
	  stmt = ''
          keywords.each do |key|
           stmt  = stmt + ' ' + key     
          end
         # puts stmt
          Feedentry.find(feed._id).set(:keywords,stmt)
       end      

    end

end

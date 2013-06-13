require 'rubygems'
require 'open-uri'
require 'readability'
require 'lingua/stemmer'

class Feedentry


  include Mongoid::Document
  field :name, type: String
  field :title, type: String
  field :summary, type: String
  field :url, type: String
  field :pubon, type: String
  field :guid, type: String
  field :type, type: String
  field :article, type: String
  field :keywords, type: String

def self.update_from_feed(feed_url,topic,feedcount)
       feed = Feedzirra::Feed.fetch_and_parse(feed_url) #parsing the rss feed
       begin    
         feed.entries.each do |entry|
          unless Feedentry.where(guid: entry.id, name: entry.title).exists? 
          #reading the complete article
          art="" 
	  begin
          source = open(entry.id).read
          art=""
          art = Readability::Document.new(source).content
          art = art.gsub /\<.*?\>/,''
          rescue
	  source = open(entry.url).read
          art=""
          art = Readability::Document.new(source).content
          art = art.gsub /\<.*?\>/,''
          end
          #----------------------------------------modified from here------------------------
          summ=entry.summary
          summ=summ.gsub /\<.*?\>/,''
	  summ=summ.gsub /nbsp/,''
          stmt =''
          
          name = feedcount.to_s()
	  create!(
          :name         => name,
	  :title  => entry.title,        
          :summary      => summ,
          :url          => entry.url,
          :pubon => entry.published,
          :guid         => entry.id,
          :type => topic,
          :article => art,  
          :keywords => feed_url
          )
 
         
 	feedcount = feedcount + 1 
          end
          
          end
 
      # In case of error while parsing the rss feeds, main article 	
      rescue
  	f=File.open("/home/newscontext/rails_projects/articles/log/Log","a+")
	f.write(topic+":"+feed_url + "\n")
	f.close  
      end
      return feedcount
  end

# This performs the task of creating files for each feed/article containing keywords.
  def self.createFiles
	@feeds= Feedentry.all
        c = 0
        @feeds.each do |feed| 
          filename = "/home/newscontext/rails_projects/articles/TextFiles/" + feed.name
          f=File.new(filename,"w")
	  f.write(feed.keywords)
	  f.close
        c = c + 1
        puts "No of files created :" + c.to_s()  
        end
  end

  def self.storeArticle
	@feeds= Feedentry.where(article: "")
	c = 0      
        @feeds.each do |feed| 
         #reading the complete article 
          if feed.article==""
	  begin
	  source = open(feed.url).read
          art = Readability::Document.new(source).content
          art = art.gsub /\<.*?\>/,''
          
          rescue

          begin
	  source = open(feed.guid).read
          art = Readability::Document.new(source).content
          art = art.gsub /\<.*?\>/,''      
          rescue
          art = ""
          end
          
          end
          Feedentry.find_by(name: feed.name).set(:article, art)        
          c = c + 1 
          puts "No of full articles stored :" + c.to_s()
	  end
          end
     end   
   
    #obtain the keywords of each feed stored considering title and summary
  def self.keywordsExtract
       # stopwordArray
	@feeds =Feedentry.all
        c = 0
        @feeds.each do |feed|
          if feed.title == nil 
          	feed.title = " "
          end
          if feed.summary == nil 
		feed.summary = " "
	  end
          
          stmt = feed.title + ' ' + feed.summary 
          stmt = stmt.downcase
	  words = stmt.scan(/\w+/)
    	  # ----------stopwords removal from the obtained list of words from the title,summary, article
          keywords = words - STOPWORDS
	  ##puts "------------------------------------------------------------------"
          
  	  ## Steming of the words
          words = keywords
          keywords = []
          stmt =''
          words.each do |key|
           stmt  = stmt + ' ' + Lingua.stemmer(key, :language=>"en")
          end
          keywords =stmt.scan(/\w+/)
          ##-----------keywords = keywords.uniq
	  stmt = ''
          keywords.each do |key|
           stmt  = stmt + ' ' + key     
          end
        Feedentry.find_by(name: feed.name).set(:keywords,stmt)
        c = c + 1 
        puts "No of feeds whose keywords are obtained :" + c.to_s()
       end      
   end
  
end

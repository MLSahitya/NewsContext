require 'rubygems'
require 'open-uri'
require 'readability'
require 'lingua/stemmer'

class Feedentry
PROJECT_PATH="/home/newscontext/rails_projects/articles"

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

# in this function we obtain the article with meta data and store into database
# it takes rss url, topic name, no of feeds as parameters

def self.update_from_feed(feed_url,topic,feedcount)
       feed = Feedzirra::Feed.fetch_and_parse(feed_url) #parsing the rss feed
       begin    
         feed.entries.each do |entry| # each rss url has multiple news stories run the loop for each story
          unless Feedentry.where(guid: entry.id, name: entry.title).exists? 
          #reading the complete article
	  #some use url for article others use id so check both 
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
          end  # begin ends
          #----------------------------------------modified from here------------------------
          summ=entry.summary
          summ=summ.gsub /\<.*?\>/,''
	  summ=summ.gsub /nbsp/,''
          stmt =''
          
          name = feedcount.to_s() # count of number of entries in the database
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
          end # unless ends
          
          end # url loop ends
 
      # In case of error while parsing the rss feeds, main article 	
      rescue
  	f=File.open("#{PROJECT_PATH}/log/Log","a+")
	f.write(topic+":"+feed_url + "\n")
	f.close  
      end # outer begin
      return feedcount
  end # function ends
 
end # class ending

class DatastoreController < ApplicationController
PROJECT_PATH="/home/newscontext/rails_projects/articles"

  # this finction passes the path of file storing the links of sources of each category of news
  # to the function within Source model
  def srcstore
  prev=Source.count
      # path where the source links of each category are stored.
   file = "#{PROJECT_PATH}/app/assets/SourceLinks/"
       group="TopStories"
       # call to Source model with file path and topic name as parameters for data storage
       Source.store_feeds(file+group,group)  
       #group="Science"
       #Source.store_feeds(file+"TopStories",group)  
       #group="Entertainment"
       #Source.store_feeds(file+group,group)  
       #group="Industries"
       #Source.store_feeds(file+group,group)  
       #group="Business"
       #Source.store_feeds(file+group,group)  
       #group="Sports"
       #Source.store_feeds(file+group,group)  
       #group="UK"
       #Source.store_feeds(file+group,group)  
  
  new =Source.count
  @count=new-prev # used in views 
  end

  # store all the feeds into the database from the sources listed in database
  def artstore

   prev=Feedentry.count
   feedcount = Feedentry.count
   @sources= Source.all
   # iterate for all sources
   @sources.each do |source| 
   # call the function in Feedentry model to store articles of a given URL
   feedcount = Feedentry.update_from_feed(source.url,source.name,feedcount)
   end
   # delete invalid data
   @feeds=Feedentry.where(pubon: nil)
   @feeds.destroy  
   new =Feedentry.count
   @artcount=new-prev    
   end


end

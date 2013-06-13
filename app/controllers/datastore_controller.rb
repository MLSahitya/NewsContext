class DatastoreController < ApplicationController
  def srcstore
  prev=Source.count
   file = "/home/newscontext/rails_projects/articles/app/assets/SourceLinks/"
       group="TopStories"
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
  @count=new-prev
  end

  def artstore
  # store all the feeds into the database from the sources listed.
   prev=Feedentry.count
   feedcount = Feedentry.count
   @sources= Source.all
   @sources.each do |source| 
   #puts source.url
   feedcount = Feedentry.update_from_feed(source.url,source.name,feedcount)
   end
   @feeds=Feedentry.where(pubon: nil)
   @feeds.destroy  
   #new =Feedentry.count
   #@artcount=new-prev
   #puts "storage of Main Article for stored feeds going on ........"
   #Feedentry.storeArticle
        
   # exporting the data to csv 
   # result = %x[mongoexport --host localhost --db articles_development -c feedentries --csv --out /home/newscontext/     rails_projects/articles/app/assets/fe.csv -f _id,name,title,summary,url,pubon,guid,type,article,keywords]
  end
end

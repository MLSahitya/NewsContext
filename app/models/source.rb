class Source
  include Mongoid::Document
  field :name, type: String
  field :url, type: String
  
  # this function takes file name, topic name as input and stores those details into the database
  def self.store_feeds(file,topic)  
      File.open(file) do |f|
      while line = f.gets  
            link= line.tr("\n",'')
          # store source links into the database 
          unless Source.where(url: link,name: topic).exists?
          create!( 
            :name     => topic,  
            :url      => link  
          ) 
          end # unless end
      end  # while end
     end # file loop
  end # function ending

end # class ends heer

class Source
  include Mongoid::Document
  field :name, type: String
  field :url, type: String
  
  def self.store_feeds(file,topic)  
      File.open(file) do |f|
      while line = f.gets  
            link= line.tr("\n",'') 
          unless Source.where(url: link,name: topic).exists?
          create!( 
            :name     => topic,  
            :url      => link  
          ) 
          end
      end  
     end  
  end

end

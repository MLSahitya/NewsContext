files=["9678","8859","9099","8762","8946","8499","8685","8079","8763"]
i=0
while i<files.length
 path="/home/newscontext/rails_projects/articles/classification/files/"+files[i]
 File.open(path) do |f|
 while line=f.gets
   words=line.scan(/\w+/)
   if words.length >1
   puts "pos/neg	"+line
   end
 end
 end 
i=i+1
end
        

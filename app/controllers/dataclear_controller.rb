class DataclearController < ApplicationController

  # from the static page srcdelete the details of sources to be deleted from the database are taken from the admin
  # based on the input the source links are deleted from the database
  def srcclear

    if (params[:topic]=="all") #params[:topic] has the input
    @sources=Source.all # select sources to be deleted
    else
    @sources = Source.where(name: params[:topic]) # select sources to be deleted
    end 
    prev=Source.count
    @sources.destroy # deletion of sources
    new=Source.count
    @srccount=prev-new
  end



  # from the static page artdelete the details of articles to be deleted from the database are taken from the admin
  # based on the input the articles and their metadata deleted from the database
  def artclear
     # select articles to be deleted
     @articles= Feedentry.where(pubon: /#{params[:date]}/,type: /#{params[:type]}/,article: /#{params[:article]}/)
     prev=Feedentry.count
     # deletion of articles from database
     @articles.destroy
     new=Feedentry.count
     @artcount=prev-new
  end

  def clusclear
  end


end

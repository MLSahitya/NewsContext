class DataclearController < ApplicationController
  def srcclear
    if (params[:topic]=="all")
    @sources=Source.all
    else
    @sources = Source.where(name: params[:topic])
    end 
    prev=Source.count
    @sources.destroy
    new=Source.count
    @srccount=prev-new
  end

  def artclear
    #if (params[:query]=="all")
    #@articles=Feedentry.all
    #else
    query="word"
    @articles= Feedentry.where(summary: /#{query}/)
    #end 
    @artcount=0
    prev=Feedentry.count
    puts @articles.count
    new=Feedentry.count
    @artcount=@articles.count#prev-new
  end

  def clusclear
  end
end

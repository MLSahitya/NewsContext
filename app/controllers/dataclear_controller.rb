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
       @articles= Feedentry.where(pubon: /#{params[:date]}/,type: /#{params[:type]}/,article: /#{params[:article]}/)
     prev=Feedentry.count
     @articles.destroy
     new=Feedentry.count
     @artcount=prev-new
  end

  def clusclear
  end
end

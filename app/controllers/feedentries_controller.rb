class FeedentriesController < ApplicationController
  @@flagf = 0
  #using to run sourceStore() only once for each application run rather than each time index is called
  # !!! move this call to a common call for all storage to take place when the application starts running
  

  # store all the feeds into the database from the sources listed.
  def storeFeeds
 	@sources= Source.all
        @sources.each do |source| 
         puts source.url
         Feedentry.update_from_feed(source.url,source.name)
        end  
        #puts "storage of Main Article for stored feeds going on ........"
        #Feedentry.storeArticle
        #puts "Extracting Keywords for the articles stored ..........."
        #Feedentry.keywordsExtract
        #Feedentry.clean
# exporting the data to csv 
 result = %x[mongoexport --host localhost --db articles_development -c feedentries --csv --out /home/newscontext/rails_projects/articles/app/assets/fe.csv -f _id,keywords]
  end

  # GET /feedentries
  # GET /feedentries.json
  def index
   #if @@flagf == 0
   #    @@flagf = 1
   #    storeFeeds
   #end
    storeFeeds
     @feedentries = Feedentry.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @feedentries }
    end
  end

  # GET /feedentries/1
  # GET /feedentries/1.json
  def show
    @feedentry = Feedentry.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @feedentry }
    end
  end

  # GET /feedentries/new
  # GET /feedentries/new.json
  def new
    @feedentry = Feedentry.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @feedentry }
    end
  end

  # GET /feedentries/1/edit
  def edit
    @feedentry = Feedentry.find(params[:id])
  end

  # POST /feedentries
  # POST /feedentries.json
  def create
    @feedentry = Feedentry.new(params[:feedentry])

    respond_to do |format|
      if @feedentry.save
        format.html { redirect_to @feedentry, notice: 'Feedentry was successfully created.' }
        format.json { render json: @feedentry, status: :created, location: @feedentry }
      else
        format.html { render action: "new" }
        format.json { render json: @feedentry.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /feedentries/1
  # PUT /feedentries/1.json
  def update
    @feedentry = Feedentry.find(params[:id])

    respond_to do |format|
      if @feedentry.update_attributes(params[:feedentry])
        format.html { redirect_to @feedentry, notice: 'Feedentry was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @feedentry.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feedentries/1
  # DELETE /feedentries/1.json
  def destroy
    @feedentry = Feedentry.find(params[:id])
    @feedentry.destroy

    respond_to do |format|
      format.html { redirect_to feedentries_url }
      format.json { head :no_content }
    end
  end
end

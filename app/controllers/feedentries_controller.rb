class FeedentriesController < ApplicationController

  # GET /feedentries
  # GET /feedentries.json
  def index
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

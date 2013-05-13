class ClustermapsController < ApplicationController
  # GET /clustermaps
  # GET /clustermaps.json
  def index
    @clustermaps = Clustermap.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @clustermaps }
    end
  end

  # GET /clustermaps/1
  # GET /clustermaps/1.json
  def show
    @clustermap = Clustermap.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @clustermap }
    end
  end

  # GET /clustermaps/new
  # GET /clustermaps/new.json
  def new
    @clustermap = Clustermap.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @clustermap }
    end
  end

  # GET /clustermaps/1/edit
  def edit
    @clustermap = Clustermap.find(params[:id])
  end

  # POST /clustermaps
  # POST /clustermaps.json
  def create
    @clustermap = Clustermap.new(params[:clustermap])

    respond_to do |format|
      if @clustermap.save
        format.html { redirect_to @clustermap, notice: 'Clustermap was successfully created.' }
        format.json { render json: @clustermap, status: :created, location: @clustermap }
      else
        format.html { render action: "new" }
        format.json { render json: @clustermap.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /clustermaps/1
  # PUT /clustermaps/1.json
  def update
    @clustermap = Clustermap.find(params[:id])

    respond_to do |format|
      if @clustermap.update_attributes(params[:clustermap])
        format.html { redirect_to @clustermap, notice: 'Clustermap was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @clustermap.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clustermaps/1
  # DELETE /clustermaps/1.json
  def destroy
    @clustermap = Clustermap.find(params[:id])
    @clustermap.destroy

    respond_to do |format|
      format.html { redirect_to clustermaps_url }
      format.json { head :no_content }
    end
  end
end

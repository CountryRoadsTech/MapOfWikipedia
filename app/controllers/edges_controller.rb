class EdgesController < ApplicationController
  before_action :set_edge, only: [:show, :edit, :update, :destroy]

  # GET /edges
  def index
    @edges = Edge.all
  end

  # GET /edges/1
  def show
  end

  # GET /edges/new
  def new
    @edge = Edge.new
  end

  # GET /edges/1/edit
  def edit
  end

  # POST /edges
  def create
    @edge = Edge.new(edge_params)

    if @edge.save
      redirect_to @edge, notice: 'Edge was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /edges/1
  def update
    if @edge.update(edge_params)
      redirect_to @edge, notice: 'Edge was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /edges/1
  def destroy
    @edge.destroy
    redirect_to edges_url, notice: 'Edge was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_edge
      @edge = Edge.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def edge_params
      params.require(:edge).permit(:graph_id, :name)
    end
end

class PathsController < ApplicationController
  before_action :set_path, only: [:show, :edit, :update, :destroy]

  # GET /paths
  def index
    @paths = Path.all
  end

  # GET /paths/1
  def show
  end

  # GET /paths/new
  def new
    @path = Path.new
  end

  # GET /paths/1/edit
  def edit
  end

  # POST /paths
  def create
    @path = Path.new(path_params)

    if @path.save
      redirect_to @path, notice: 'Path was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /paths/1
  def update
    if @path.update(path_params)
      redirect_to @path, notice: 'Path was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /paths/1
  def destroy
    @path.destroy
    redirect_to paths_url, notice: 'Path was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_path
      @path = Path.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def path_params
      params.require(:path).permit(:name)
    end
end

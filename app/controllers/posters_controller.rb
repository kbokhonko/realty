class PostersController < ApplicationController

  def index
    if current_user.nil?
      @posters = Poster.all
    else
      @posters = current_user.posters
    end

    respond_to do |format|
      format.html
      format.json { render json: @posters }
    end
  end

  def show
    @poster = Poster.find(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @poster }
    end
  end

  def new
   @poster = Poster.new(params[:poster])
   #@poster = current_user.posters.build
  end

  def edit
    @poster = Poster.find(params[:id])
  end

  def create
    @poster = current_user.posters.build(params[:poster])

    if verify_recaptcha
      @poster.save
      redirect_to [current_user, @poster]
    else
      flash[:recaptcha_error] = "There was an error with the recaptcha code below. Please re-enter the code and click submit."
      redirect_to new_user_poster_path
    end

  end

  def update
    @poster = Poster.find(params[:id])

    respond_to do |format|
      if @poster.update_attributes(params[:poster])
        format.html { redirect_to [current_user, @poster], notice: 'Poster was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @poster.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @poster = Poster.find(params[:id])
    @poster.destroy

    respond_to do |format|
      format.html { redirect_to user_posters_url }
      format.json { head :no_content }
    end
  end
end

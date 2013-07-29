class CommentsController < ApplicationController
  def new
  end

  def create
    @poster = Poster.find(params[:poster_id])
    params[:comment][:user_id] = current_user.id
    @comment = @poster.comments.build(params[:comment])
    respond_to do |format|
      if @comment.save
        format.js
     end
  end
  end

  def show
  end

  def edit
  end

  def update
  end
end

class CommentsController < ApplicationController
  respond_to :html
  
  before_filter :login_required, :only=>['new','create']

  def index
    @comments = Comment.all
  end

  def show
    @comment = Comment.find(params[:id])
  end

  def new  
    @review = Review.find(params[:review_id])
    @user = current_user
    @comment = @review.comments.build
    @comment.user = @user
    @comment.build_like
    respond_with(@comment)
  end

  def create  
    @review = Review.find(params[:review_id])
    @user = current_user
    @comment = @review.comments.build(params[:comment])
    @comment.user = @user
    @comment.save
    #send email to remind the user whose review is commented
    
    commenter = @user
    if commenter!=@review.user
      @review.user.delay.comment_remind( commenter)
    end
    redirect_to phone_review_path(@review.phone, @review)
  end

  def edit
    @comment = Comment.find(params[:id])
    @can_edit = can_edit(@comment.user)
    if @can_edit
      respond_with(@comment)  
    else
      flash[:warning] = "You cannot edit this comment!"
      redirect_to phone_review_comment_path(@comment.review.phone, @comment.review, @comment)
    end
  end

  def update
    @comment = Comment.find(params[:id])
    @comment.update_attributes!(params[:comment])
    redirect_to phone_review_path(@comment.review.phone, @comment.review)
  end


  def destroy
    @comment = Comment.find(params[:id])
    @can_edit = can_edit(@comment.user)
    if @can_edit
      @comment.destroy
      flash[:message] = "Comment deleted."
      redirect_to phone_review_path(@comment.review.phone, @comment.review)
    else
      flash[:warning] = "You cannot delete this comment!"
      redirect_to phone_review_path(@comment.review.phone, @comment.review)
    end
  end
end

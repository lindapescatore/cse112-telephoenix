class PhonesController < ApplicationController
  def index
   
    @num_per_page = 20
    @num_all  = Phone.count
    @num_pages = (@num_all.to_f/@num_per_page).ceil

    @phones = Phone.all
    @sort_by = params[:sort_by]
    @current_page = params[:page].nil? ?  1 : params[:page].to_i 
   
   
    @phones = Phone.phones_on_page :sort_by => @sort_by, :current_page => @current_page, :num_per_page => @num_per_page 
  
    @pages_bar = []
    @pages_bar[1] = 1
    i = 1
    if @current_page<=4
       while i <= @current_page
          @pages_bar[i] = i
          i = i+1
       end
    else
       @pages_bar[2] = "..."
       @pages_bar[3 .. 4] = [@current_page-1, @current_page]
       i = 5
    end
    if @current_page< @num_pages-1
       @pages_bar[i .. i+2] = [@current_page+1, "...", @num_pages]
    elsif @current_page< @num_pages
       @pages_bar[i] = @current_page+1
    end 
         
  end


  def show
    
    @phone = Phone.find(params[:id])
    @tags = Tag.find_all_by_phone_id(params[:id])
    @ratings = Rating.find_all_by_phone_id(params[:id])
    @reviews = Review.find_all_by_phone_id(params[:id])
    @overallrate = @phone.overallRatings()
    @prorating = @phone.proRating()
    @userrating = @phone.userRating()
  end

  def create
  	@phones = Phone.search(params[:name])
  end
end

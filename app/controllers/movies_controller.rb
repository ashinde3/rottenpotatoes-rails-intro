class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :sort)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    
    if (params[:ratings] == nil && session[:ratings] != nil) ||
       (params[:sort] == nil && session[:sort] != nil)
      flash.keep
      redirect_to movies_path(ratings: session[:ratings] || params[:ratings], sort: session[:sort] || params[:sort])
    end
    
    session[:sort] = params[:sort]
    session[:ratings] = params[:ratings]
    
    @all_ratings = ['G','PG','PG-13','R','NC-17']
    ratings = params[:ratings] != nil ? params[:ratings].keys : @all_ratings
  
    @rating_checked = Hash[@all_ratings.map{|r| [r, ratings.include?(r)]}]
    
    @movies = Movie.where(rating: ratings)

    
  	if params[:sort] == "title" 
  		@movies = @movies.all.sort_by{|e| e[:title]}
  	elsif params[:sort] == "release_date" 
  		@movies = @movies.all.sort_by{|e| e[:release_date]}
  	end
  	
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
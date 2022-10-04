class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @session_needed = 0 
    if params.length == 0
        @ratings_to_show = session[:ratings]
	@session_needed = 1
	if @ratings_to_show == nil
	    @ratings_to_show = []
	end
    end 
    @movie_class= "idk"
    @release_class= "idk"
    @all_ratings = Movie.all_ratings
    if @session_needed == 0
    	@ratings_to_show = []
    	if params[:ratings] != nil
    	    params[:ratings].each do |key, value|
	        @ratings_to_show.append(key)	
    	    end
	    session[:ratings] = @ratings_to_show
        end
    end
    if params[:sort_movies]
	@ratings_to_show = params[:boxes_checked]
        @movies = Movie.sort_movies(@ratings_to_show, "Movie")
	@movie_class= "p-3 mb-2 bg-warning text-dark hilite"
	session[:sorting] = "Movie"
    elsif params[:sort_release]
	@ratings_to_show = params[:boxes_checked]
	@movies = Movie.sort_movies(@ratings_to_show, "Release")
	@release_class= "p-3 mb-2 bg-warning text-dark hilite"
	session[:sorting] = "Release"
    elsif session[:sorting] == "Movie"
	@movies = Movie.sort_movies(@ratings_to_show, "Movie")
    elsif session[:sorting] == "Release"
	@movies = Movie.sort_movies(@ratings_to_show, "Release")
    else 
    	@movies = Movie.with_ratings(@ratings_to_show)
    end
    if @ratings_to_show == nil
        @ratings_to_show = [] 
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end

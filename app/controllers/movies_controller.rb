class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movie_classOne = "idk"
    @movie_classTwo = "idk"
    @release_classOne = "idk"
    @release_classTwo = "idk"
    @all_ratings = Movie.all_ratings
    @ratings_to_show = []
    if params[:ratings] != nil
    	params[:ratings].each do |key, value|
	    @ratings_to_show.append(key)	
    	end
    end
    if params[:sort_movies]
        @movies = Movie.sort_movies(@ratings_to_show, "Movie")
	@movies_classOne = "p-3 mb-2 bg-warning text-dark"
	@movies_classTwo = "hilite"
    elsif params[:sort_release]
	@movies = Movie.sort_movies(@ratings_to_show, "Release")
	@release_classOne= "p-3 mb-2 bg-warning text-dark"
	@release_classTwo= "hilite"
    else 
    	@movies = Movie.with_ratings(@ratings_to_show)
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

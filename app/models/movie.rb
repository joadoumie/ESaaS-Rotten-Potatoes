class Movie < ActiveRecord::Base
    def self.with_ratings(ratings_list)
  	    # if ratings_list is an array such as ['G', 'PG', 'R'], retrieve all
  	    #  movies with those ratings
            # if ratings_list is nil, retrieve ALL movies
        if ratings_list == nil || ratings_list == [] 
	    return Movie.all
	else
	    return Movie.where(rating:ratings_list)
	end
    end

    def self.all_ratings()
	return Movie.distinct.pluck(:rating)
    end

    def self.sort_movies(ratings_list, sort_type)
	if sort_type == "Movie"
	    return self.with_ratings(ratings_list).order(rating: desc)
	elsif sort_type == "Release"
	    return self.with_ratings(ratings_liit).order(release_date: desc)
        end
    end
end

require 'rack-flash'
class SongController < ApplicationController
  use Rack::Flash


  get '/songs' do
    @songs = Song.all
    erb :'/songs/index' 
  end

  get '/songs/new' do
  	@artists = Artist.all
  	erb :'/songs/new'
  end

   get '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    erb :'songs/show'
  end

  post '/songs' do
  	@song = Song.create(name: params["Name"])
    @song.artist = Artist.find_or_create_by(name: params["Artist Name"])
    @song.genre_ids = params[:genres]
    @song.save
  
    flash[:message] = "Successfully created song."
    redirect "/songs/#{@song.slug}"
  #post is going to post and create a slug and redirect to 'songs/:slug"
  end

  get '/songs/:slug/edit' do
    @song = Song.find_by_slug(params[:slug])
    erb :'songs/edit'
  end

  post '/songs/:slug' do
    @song = Song.find_by_slug(params[:slug])
    @song.artist.name = params["Artist Name"]
    @song.genres = params["genres[]"]
    @song.save
 
    flash[:message] = "Successfully updated song."
    redirect("/songs/#{@song.slug}")
  end

end
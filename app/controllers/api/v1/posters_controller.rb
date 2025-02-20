class Api::V1::PostersController < ApplicationController
  def index
    if params[:sort] == "asc"
      posters = Poster.sort_by_asc 
    elsif params[:sort] == "desc"
      posters = Poster.sort_by_desc 
    elsif params[:name].present?
      posters = Poster.filter_by_name(params[:name])
    elsif params[:max_price].present?
      posters = Poster.max_by(params[:max_price])
    elsif params[:min_price].present?
      posters = Poster.min_by(params[:min_price])
    else 
      posters = Poster.all  
    end
    render json: PosterSerializer.format_posters(posters)
  end

  def show
    poster = Poster.find(params[:id])
    render json: PosterSerializer.format_single_poster(poster)
  end

  def create
    created_poster = Poster.create(poster_params)
    render json: PosterSerializer.format_single_poster(created_poster)
  end

  def update
    updated_poster = Poster.update(params[:id], poster_params)
    render json: PosterSerializer.format_single_poster(updated_poster)
  end

  def destroy
    render json: Poster.delete(params[:id])
  end

  private

  def poster_params
    params.require(:poster).permit(:name, :description, :price, :year, :vintage, :img_url)
  end
  
end
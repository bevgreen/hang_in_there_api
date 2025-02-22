class Api::V1::PostersController < ApplicationController
  def index
    posters = Poster.all
    posters = posters.filter_by_name(params[:name]) if params[:name].present?
    posters = posters.filter_by_max_price(params[:max_price]) if params[:max_price].present?
    posters = posters.filter_by_min_price(params[:min_price]) if params[:min_price].present?
  
    if params[:sort] == "asc"
      posters = posters.sort_by_asc
    elsif params[:sort] == "desc"
      posters = posters.sort_by_desc
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
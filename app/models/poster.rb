class Poster < ApplicationRecord

  def self.sort_by_asc
    Poster.order(created_at: :asc)
  end

  def self.sort_by_desc
    Poster.order(created_at: :desc)
  end

  def self.filter_by_name(name_param)
    posters = Poster.all
    found_posters = posters.find_all { |poster| poster.name.include?(name_param.upcase) }
    poster = found_posters.sort_by { |poster| poster.name }
  end

  def self.filter_by_max_price(price_param)
    posters = Poster.all
    poster = posters.find_all { |poster| poster.price.to_f <= (price_param.to_f)}
  end

  def self.filter_by_min_price(price_param)
    posters = Poster.all
    poster = posters.find_all { |poster| poster.price.to_f >= (price_param.to_f)}
  end
  
end

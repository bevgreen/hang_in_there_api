class Poster < ApplicationRecord

  def self.sort_by_asc
    Poster.order(created_at: :asc)
  end

  def self.sort_by_desc
    Poster.order(created_at: :desc)
  end

  def self.filter_by_name(name_param)
    posters = Poster.all
    poster = posters.find_all { |poster| poster.name.include?(name_param.upcase) }
  end

  def self.max_by(price_param)
    posters = Poster.all
    poster = posters.find_all { |poster| poster.price <= (price_param.to_f)}
  end

  def self.min_by(price_param)
    posters = Poster.all
    poster = posters.find_all { |poster| poster.price >= (price_param.to_f)}
  end
  
end

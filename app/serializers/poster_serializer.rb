class PosterSerializer
  def self.format_posters(posters)
    {
      data: posters.map do |poster|
        {
          id: poster.id,
          type: "poster",  
          attributes: {
            name: poster.name,
            description: poster.description,
            price: poster.price.to_f,
            year: poster.year,
            vintage: poster.vintage,
            img_url: poster.img_url
          }
        }
      end,
      meta: {
        count: posters.length
      }
    }
  
end

  def self.format_single_poster(poster)
    {
      data:
        {
          id: poster.id,
          type: "poster",  
          attributes: {
            name: poster.name,
            description: poster.description,
            price: poster.price.to_f,
            year: poster.year,
            vintage: poster.vintage,
            img_url: poster.img_url
          }
        }
    }
  end
end


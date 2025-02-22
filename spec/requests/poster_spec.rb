require "rails_helper.rb"

RSpec.describe Poster, type: :request do
    describe "Posters API" do
        it "sends a list of posters" do
            Poster.create!(name: "DISASTER", 
                            description: "It's too late to start now.", 
                            price: 35.00, 
                            year: 2023, 
                            vintage: false, 
                            img_url:"https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk"
                            )
            Poster.create!(name: "REGRET",
                            description: "Hard work rarely pays off.",
                            price: 89.00,
                            year: 2018,
                            vintage: true,
                            img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
                            )            
            Poster.create!(name: "SADNESS",
                            description: "There are no more snacks in my house",
                            price: 62.00,
                            year: 1989,
                            vintage: true,
                            img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
                            )
            get "/api/v1/posters"
            expect(response).to be_successful
            posters = JSON.parse(response.body, symbolize_names: true)
            expect(posters[:data].count).to eq(3)
            # binding.pry
            posters[:data].each do |poster|
                expect(poster).to have_key(:id)
                expect(poster[:id]).to be_a(Integer)
                
                expect(poster).to have_key(:type)
                expect(poster[:type]).to eq("poster")

                expect(poster).to have_key(:attributes)
                expect(poster[:attributes]).to be_a(Hash)

                expect(poster[:attributes]).to have_key(:name)
                expect(poster[:attributes][:name]).to be_a(String)

                expect(poster[:attributes]).to have_key(:description)
                expect(poster[:attributes][:description]).to be_a(String)

                expect(poster[:attributes]).to have_key(:price)
                expect(poster[:attributes][:price]).to be_a(Float)

                expect(poster[:attributes]).to have_key(:year)
                expect(poster[:attributes][:year]).to be_a(Integer)

                expect(poster[:attributes]).to have_key(:vintage)
                expect(poster[:attributes][:vintage]).to be_a(TrueClass).or be_a(FalseClass) 

                expect(poster[:attributes]).to have_key(:img_url)
                expect(poster[:attributes][:img_url]).to be_a(String)
            end
            
        end
    end
end
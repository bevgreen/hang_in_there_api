require "rails_helper.rb"

RSpec.describe Poster, type: :request do
    describe "Posters API" do
        it "sends a list of all posters with correct attributes" do
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

        it "can select exact poster to show by the id #show" do
            id = Poster.create!(name: "DISASTER", 
                                description: "It's too late to start now.", 
                                price: 35.00, 
                                year: 2023, 
                                vintage: false, 
                                img_url:"https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk"
                                ).id

            get "/api/v1/posters/#{id}"
            poster = JSON.parse(response.body, symbolize_names: true)
            expect(poster[:data]).to have_key(:id)
            expect(poster[:data][:id]).to be_a(Integer)

            expect(poster[:data]).to have_key(:type)
            expect(poster[:data][:type]).to eq("poster")

            expect(poster[:data]).to have_key(:attributes)
            expect(poster[:data][:attributes]).to be_a(Hash)

            expect(poster[:data][:attributes]).to have_key(:name)
            expect(poster[:data][:attributes][:name]).to be_a(String)

            expect(poster[:data][:attributes]).to have_key(:description)
            expect(poster[:data][:attributes][:description]).to be_a(String)

            expect(poster[:data][:attributes]).to have_key(:price)
            expect(poster[:data][:attributes][:price]).to be_a(Float)

            expect(poster[:data][:attributes]).to have_key(:year)
            expect(poster[:data][:attributes][:year]).to be_a(Integer)

            expect(poster[:data][:attributes]).to have_key(:vintage)
            expect(poster[:data][:attributes][:vintage]).to be_a(TrueClass).or be_a(FalseClass) 

            expect(poster[:data][:attributes]).to have_key(:img_url)
            expect(poster[:data][:attributes][:img_url]).to be_a(String)
        end

        it "can create a poster #create" do
            poster_params = {
                            name: "DISASTER", 
                            description: "It's too late to start now.", 
                            price: 35.00, 
                            year: 2023, 
                            vintage: false, 
                            img_url:"https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk"
                            }

            headers = { "CONTENT_TYPE" => "application/json" }
            post "/api/v1/posters", headers: headers, params: JSON.generate(poster: poster_params)
            created_poster = Poster.last
        
            expect(response).to be_successful
            expect(created_poster.name).to eq(poster_params[:name])
            expect(created_poster.description).to eq(poster_params[:description])
            expect(created_poster.price).to eq(poster_params[:price])
            expect(created_poster.year).to eq(poster_params[:year])
            expect(created_poster.vintage).to eq(poster_params[:vintage])
            expect(created_poster.img_url).to eq(poster_params[:img_url])
        end

        it "can update attributes of an existing poster#update" do
            id = Poster.create!(name: "DISASTER", 
                                description: "It's too late to start now.", 
                                price: 35.00, 
                                year: 2023, 
                                vintage: false, 
                                img_url:"https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk"
                                ).id

            previous_name = Poster.last.name
            poster_params = { name: "CATASTROPHE" }
            headers = {"CONTENT_TYPE" => "application/json"}
            patch "/api/v1/posters/#{id}", headers: headers, params: JSON.generate({poster: poster_params})
            poster = Poster.find_by(id: id)

            expect(response).to be_successful
            expect(poster.name).to_not eq(previous_name)
            expect(poster.name).to eq("CATASTROPHE")
        end

        it "can destroy a poster#destroy" do
            poster = Poster.create!(name: "DISASTER", 
                                    description: "It's too late to start now.", 
                                    price: 35.00, 
                                    year: 2023, 
                                    vintage: false, 
                                    img_url:"https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk"
                                    )

            expect(Poster.count).to eq(1)
            delete "/api/v1/posters/#{poster.id}"
            expect(response).to be_successful
            expect(Poster.count).to eq(0)
            expect{ Poster.find(poster.id) }.to raise_error(ActiveRecord::RecordNotFound)
        end

        it "can sort posters in ascending creation order" do
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
                                        
            get "/api/v1/posters?sort=asc"
            expect(response).to be_successful
            posters = JSON.parse(response.body, symbolize_names: true)
            sorted_posters = posters[:data].map { |poster| poster[:attributes][:name] }
            expect(sorted_posters).to eq(["DISASTER", "REGRET", "SADNESS"])
        end

        it "can sort posters in descending creation order" do
            Poster.create!(name: "SADNESS",
                            description: "There are no more snacks in my house",
                            price: 62.00,
                            year: 1989,
                            vintage: true,
                            img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
                            )
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
                                                
            get "/api/v1/posters?sort=desc"
            expect(response).to be_successful
            posters = JSON.parse(response.body, symbolize_names: true)
            sorted_posters = posters[:data].map { |poster| poster[:attributes][:name] }
            expect(sorted_posters).to eq(["REGRET", "DISASTER", "SADNESS"])
        end

        it "can filter posters by specific name" do
            Poster.create!(name: "SADNESS",
                            description: "There are no more snacks in my house",
                            price: 62.00,
                            year: 1989,
                            vintage: true,
                            img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
                            )
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

            get "/api/v1/posters?name=re"
            expect(response).to be_successful
            posters = JSON.parse(response.body, symbolize_names: true)            
            sorted_posters = posters[:data].map { |poster| poster[:attributes][:name] }  
            expect(sorted_posters).to eq(["REGRET"])
        end

        it "can sort posters by max price" do
            Poster.create!(name: "SADNESS",
                            description: "There are no more snacks in my house",
                            price: 62.00,
                            year: 1989,
                            vintage: true,
                            img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
                            )
            Poster.create!(name: "DISASTER", 
                            description: "It's too late to start now.", 
                            price: 35.00, 
                            year: 2023, 
                            vintage: false, 
                            img_url:"https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk"
                            )
            Poster.create!(name: "REGRET",
                            description: "Hard work rarely pays off.",
                            price: 102.00,
                            year: 2018,
                            vintage: true,
                            img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
                            )

            get "/api/v1/posters?max_price=99.00"
            expect(response).to be_successful
            posters = JSON.parse(response.body, symbolize_names: true)            
            sorted_posters = posters[:data].map { |poster| poster[:attributes][:name] }  
            expect(sorted_posters).to eq(["SADNESS", "DISASTER"])
        end

        it "can sort posters by min price" do
            Poster.create!(name: "SADNESS",
                            description: "There are no more snacks in my house",
                            price: 62.00,
                            year: 1989,
                            vintage: true,
                            img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
                            )
            Poster.create!(name: "DISASTER", 
                            description: "It's too late to start now.", 
                            price: 35.00, 
                            year: 2023, 
                            vintage: false, 
                            img_url:"https://unsplash.com/photos/brown-brick-building-with-red-car-parked-on-the-side-mMV6Y0ExyIk"
                            )
            Poster.create!(name: "REGRET",
                            description: "Hard work rarely pays off.",
                            price: 102.00,
                            year: 2018,
                            vintage: true,
                            img_url:  "https://plus.unsplash.com/premium_photo-1661293818249-fddbddf07a5d"
                            )

            get "/api/v1/posters?min_price=99.00"
            expect(response).to be_successful
            posters = JSON.parse(response.body, symbolize_names: true)            
            sorted_posters = posters[:data].map { |poster| poster[:attributes][:name] }  
            expect(sorted_posters).to eq(["REGRET"])
        end
    end
end
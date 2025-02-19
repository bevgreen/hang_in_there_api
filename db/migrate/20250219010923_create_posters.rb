class CreatePosters < ActiveRecord::Migration[7.1]
  def change
    create_table :posters do |t|
      t.integer :id
      t.string :name
      t.string :description
      t.float :price
      t.integer :year
      t.boolean :vintage
      t.string :img_url
      t.timestamp :created_at
      t.timestamp :updated_at

      t.timestamps
    end
  end
end

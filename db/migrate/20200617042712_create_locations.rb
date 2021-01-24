class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.text :content
      t.references :user, foreign_key: true

      t.timestamps
    end
    add_index :locations, [:user_id, :created_at]
  end
end

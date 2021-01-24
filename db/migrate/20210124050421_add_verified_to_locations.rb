class AddVerifiedToLocations < ActiveRecord::Migration[5.2]
  def change
    add_column :locations, :verified, :boolean
  end
end

class RemoveOldStlyleFromBeer < ActiveRecord::Migration
  def up
    remove_column :beers, :old_style, :string
  end

  def down
    add_column :beers, :old_style, :string
  end
end

class MoveOldStylesToStyleTable < ActiveRecord::Migration
  def up
    styles_names = Beer.all.map(&:old_style).uniq
    styles_names.each do |style_name|
      Style.create name: style_name
    end

    Beer.all.each do |beer|
      beer.style = Style.find_by_name beer.old_style
      beer.save
    end
  end

  def down
    Beer.all.each do |beer|
      beer.old_style = beer.style.name
    end

    Style.all.each do |style|
      style.delete
    end
  end
end

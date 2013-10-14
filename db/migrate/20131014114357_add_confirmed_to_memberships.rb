class AddConfirmedToMemberships < ActiveRecord::Migration
  def up
    add_column :memberships, :confirmed, :boolean, default: false
    Membership.all.each {|m| m.confirmed = true; m.save }
  end

  def down
    remove_column :memberships, :confirmed, :boolean
  end
end

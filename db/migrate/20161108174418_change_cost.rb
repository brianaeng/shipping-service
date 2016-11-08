class ChangeCost < ActiveRecord::Migration
  def change
    add_column :estimates, :costs, :string, array: true, default: []
    remove_column :estimates, :cost, :text
  end
end

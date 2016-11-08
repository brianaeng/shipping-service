class UpdateCost < ActiveRecord::Migration
  def change
    remove_column :estimates, :cost, :integer
    add_column :estimates, :cost, :text, array: true, default: []
  end
end

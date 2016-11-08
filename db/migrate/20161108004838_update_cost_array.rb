class UpdateCostArray < ActiveRecord::Migration
  def change
    remove_column :estimates, :cost, :text
    add_column :estimates, :cost, :text
  end
end

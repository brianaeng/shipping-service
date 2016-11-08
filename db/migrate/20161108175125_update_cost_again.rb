class UpdateCostAgain < ActiveRecord::Migration
  def change
    change_column :estimates, :costs, :string, array: true, default: []
  end
end

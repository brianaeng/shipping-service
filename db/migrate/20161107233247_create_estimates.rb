class CreateEstimates < ActiveRecord::Migration
  def change
    create_table :estimates do |t|
      t.string :name
      t.integer :cost

      t.timestamps null: false
    end
  end
end

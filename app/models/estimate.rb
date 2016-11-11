class Estimate < ActiveRecord::Base
  serialize :costs
  validates :name, presence: true
  validates :costs, presence: true

end

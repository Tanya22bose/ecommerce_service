class LineItem < ApplicationRecord
  belongs_to :order
  after_save :update_order_total_price
  after_destroy :update_order_total_price

  validates :order_id, presence: true
  validates :product_id, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than: 0.0 }

  private 
  def update_order_total_price
    order.calculate_total_price
  end

end

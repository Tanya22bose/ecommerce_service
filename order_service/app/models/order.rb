class Order < ApplicationRecord
    has_many :line_items, dependent: :destroy

    validates :line_items, length: { minimum: 1, message: "should have at least one item" }
    validates :status, inclusion: { in: ["cart", "payment", "checkout", "complete", "cancelled"], message: "invalid status" }
    validates :total_price, presence: true, numericality: { greater_than: 0.0 }
  
    def calculate_total_price
      self.total_price = line_items.sum { |item| item.price * item.quantity }
      save
    end
  end
  
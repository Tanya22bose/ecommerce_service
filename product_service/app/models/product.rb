class Product < ApplicationRecord
    has_many_attached :images

    validates :name, presence: true
    validates :description, length: {minimum: 10}
    validates :price, presence: true
    validate :image_type, if: :image_attached?
    
    def image_attached?
        images.attached?
    end

    def image_type
        images.each do |image|
            if !image.content_type.in?(["image/png", "image/jpeg", "image/gif"])
                errors.add(:images, "Must be a JPEG, PNG or GIF")
            end
        end
    end
end
class ProductsController < ApplicationController
  before_action :authenticate_user, only: [:create, :destroy, :update]
  before_action :set_product, only: [:show, :update, :destroy]

  def index
      @products = Product.all
      render json: @products, status: :ok
  end

  def show
      if @product
          render json: @product, status: :ok
      else
          head :internal_server_error
      end
  end

  def create
      @product = Product.new(product_params)
      attach_images if product_params[:images]

      if @product.save
          render json: @product, status: :created
      else
          render json: {error: @product.errors.full_messages}, status: :unprocessable_entity
      end

  end

  def update
      attach_images if product_params[:images]
      
      if @product.update(product_params)
          render json: @product, status: :created
      else
          render json: {error: @product.errors.full_messages}, status: :unprocessable_entity
      end
  end

  def destroy
      if @product.destroy
          head :no_content
      else
          head :internal_server_error 
      end
  end

  private

  def set_product
      @product = Product.find(params[:id])
      rescue ActiveRecord::RecordNotFound
          render json: {error: "Product not found"}, status: :not_found
  end

  def attach_images
      product_params[:images].each do |image|
          @product.images.attach(image)
      end
  end

  def product_params
      params.permit(:name, :description, :price, images: [])
  end
end
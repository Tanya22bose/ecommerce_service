class OrdersController < ApplicationController
  before_action :authenticate_user, only: [:create, :update, :destroy]

  def response_in_json(response_items, status_code)
    render json: response_items, status: status_code
  end

  def index
    #get all the orders in the database
    @orders = Order.all
    response_in_json({orders: @orders}, :ok)
  end

  def show
    #get all the order_items for a specific order
    @order_items = LineItem.where({order_id: params[:id]}).all
    if @order_items.length > 0 
      response_in_json({ order_items: @order_items }, :ok)
    else
      response_in_json({ error: "Order not found" }, :not_found)
    end
  end
  
  def create
    # Find or initialize the order if it doesn't exist
    @order = Order.find_or_initialize_by(user_id: @current_user_id, status: "cart")
    
    @line_item = LineItem.find_by({product_id: order_params[:product_id], order_id: @order.id})
    
    if @line_item
      # find the product in the line items collection, and update the quantity if it exists
      @line_item.update({
        quantity: @line_item.quantity.to_i + order_params[:quantity].to_i,
        price: order_params[:price]
      })
    else
      # if it doesn't exist then create a new line items array for the order
      @line_item = @order.line_items.build({
        product_id: order_params[:product_id],
        quantity: order_params[:quantity],
        price: order_params[:price]
      })
    end
    
    if @order.save
      response_in_json({order: @order}, :created)
    else
      response_in_json({errors: @order.errors.full_messages}, :unprocessable_entity)
    end
  end 

  def update
    @line_item = LineItem.find_by({product_id: order_params[:product_id], order_id: params[:id]})
    #if line_item exists then only it should update
    if @line_item.update({
      quantity: order_params[:quantity],
    })
      response_in_json({ message: "Product updated successfully!"}, :no_content)
    else
      response_in_json({errors: "Product doesn't exist"}, :unprocessable_entity)
    end
  end

  def destroy
    @order = Order.find_by({id: params[:id], user_id: @current_user_id, status: "cart"})
    @line_item = @order.line_items.find_by({product_id: order_params[:product_id]})
    if @order.line_items.length > 1 && @line_item.destroy
      response_in_json({message: "Product deleted successfully!"}, status: :ok)
    else
      response_in_json({error: "Cart should atleast have one item inside it!"}, :internal_server_error)
    end
  end

  private
  def order_params
    params.permit(:user_id, :status, :total_price, :product_id, :quantity, :price, :order_id)
  end

end

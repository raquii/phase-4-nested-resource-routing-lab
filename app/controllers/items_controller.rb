class ItemsController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :render_resp_not_found
  
  def index
    if params[:user_id]
      user = find_user
      items = user.items
    else
      items = Item.all
    end
    render json: items, include: :user
  end
  
  def show
    item = find_item
    render json: item, include: :user
  end

  def create
    item = Item.create(item_params)
    render json: item, include: :user, status: :created
  end

  private

  def render_resp_not_found
    render json: { error: "Item not found" }, status: :not_found
  end

  def find_item
    Item.find(params[:id])
  end

  def find_user
    User.find(params[:user_id])
  end

  def item_params
    params.permit(:name, :description, :price, :user_id)
  end

end

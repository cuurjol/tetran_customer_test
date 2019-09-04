class CustomersController < ApplicationController
  before_action :set_customer, only: %i[edit update destroy add_to_blacklist destroy_from_blacklist]

  def index
    @customers = Customer.where(blacklist: false)
  end

  def blacklist
    @customers = Customer.where(blacklist: true)
  end

  def add_to_blacklist
    @customer.blacklist = true
    @customer.save

    redirect_to(root_path, notice: 'Customer was successfully added to blacklist.')
  end

  def destroy_from_blacklist
    @customer.blacklist = false
    @customer.save

    redirect_to(blacklist_customers_path, notice: 'Customer was successfully destroyed from blacklist.')
  end

  def new
    @customer = Customer.new
  end

  def edit
  end

  def create
    @customer = Customer.new(customer_params)

    if @customer.save
      redirect_to(root_path, notice: 'Customer was successfully created.')
    else
      render(:new)
    end
  end

  def update
    if @customer.update(customer_params)
      redirect_to(root_path, notice: 'Customer was successfully updated.')
    else
      render :edit
    end
  end

  def destroy
    @customer.destroy
    redirect_to customers_url, notice: 'Customer was successfully destroyed.'
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:name, :phone, :description, :description)
  end
end

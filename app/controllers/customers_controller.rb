class CustomersController < ApplicationController
  before_action :set_customer, only: %i[edit update destroy ban unban]
  before_action :set_customer_by_phone, only: :add_to_blacklist

  def index
    @customers = Customer.where(blacklist: false)
  end

  def blacklist
    @customer = Customer.new
    @customers = Customer.where(blacklist: true)
  end

  def ban
    @customer.blacklist = true
    @customer.save

    redirect_to(root_path, notice: 'Customer was successfully banned.')
  end

  def unban
    @customer.blacklist = false
    @customer.save

    render(blacklist_customers_path, notice: 'Customer was successfully unbanned.')
  end

  def add_to_blacklist
    if @customer.nil?
      @customers = Customer.where(blacklist: true)
      flash.now[:notice] = "Customer was not found by phone: #{params[:phone]}"
      render(:blacklist)
    else
      @customer.blacklist = true
      @customer.save

      redirect_to(blacklist_customers_path, notice: 'Customer was successfully added to blacklist.')
    end
  end

  def new
    @customer = Customer.new
  end

  def edit; end

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
    redirect_to(customers_url, notice: 'Customer was successfully destroyed.')
  end

  private

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def set_customer_by_phone
    @customer = Customer.find_by_phone(params[:phone])
  end

  def customer_params
    params.require(:customer).permit(:name, :phone, :description)
  end
end

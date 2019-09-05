require 'rails_helper'

RSpec.describe CustomersController, type: :controller do
  render_views

  describe '#index' do
    context 'when all customers are not banned' do
      before(:each) { FactoryBot.create_list(:customer, 3) }
      before(:each) { get(:index) }

      it 'returns list of customers' do
        expect(assigns(:customers)).to_not be_nil
        expect(assigns(:customers).count).to eq(3)
      end

      it 'renders index view' do
        expect(response.status).to eq(200)
        expect(response).to render_template(:index)
        expect(response.body).to match('List of customers')
      end
    end
  end

  describe '#blacklist' do
    context 'when all customers are banned' do
      before(:each) { FactoryBot.create_list(:customer, 3, blacklist: true) }
      before(:each) { get(:blacklist) }

      it 'returns list of customers' do
        expect(assigns(:customers)).to_not be_nil
        expect(assigns(:customers).count).to eq(3)
      end

      it 'renders blacklist view' do
        expect(response.status).to eq(200)
        expect(response).to render_template(:blacklist)
        expect(response.body).to match('Blacklist of customers')
      end
    end
  end

  describe '#ban' do
    context 'when customer will be banned' do
      let(:customer) { FactoryBot.create(:customer) }
      before(:each) { put(:ban, params: { id: customer.id }) }

      it 'successfully bans customer' do
        expect(customer.reload.blacklist).to be_truthy
      end

      it 'redirects to index view' do
        expect(response.status).to eq(302)
        expect(response).to redirect_to(root_path)
        expect(flash[:success]).to eq('Customer was successfully banned.')
      end
    end
  end

  describe '#unban' do
    context 'when customer will be unbanned' do
      let(:customer) { FactoryBot.create(:customer, blacklist: true) }
      before(:each) { put(:unban, params: { id: customer.id }) }

      it 'successfully unbans customer' do
        expect(customer.reload.blacklist).to be_falsey
      end

      it 'redirects to blacklist view' do
        expect(response.status).to eq(302)
        expect(response).to redirect_to(blacklist_customers_path)
        expect(flash[:success]).to eq('Customer was successfully unbanned.')
      end
    end
  end

  describe '#add_to_blacklist' do
    let!(:customer) { FactoryBot.create(:customer, phone: '123-456-7890') }

    context 'when customer will be found by phone and added to blacklist' do
      before(:each) { post(:add_to_blacklist, params: { phone: '123-456-7890' }) }

      it 'successfully bans customer by phone' do
        expect(customer.reload.blacklist).to be_truthy
      end

      it 'redirects to blacklist view' do
        expect(response.status).to eq(302)
        expect(response).to redirect_to(blacklist_customers_path)
        expect(flash[:success]).to eq('Customer was successfully added to blacklist.')
      end
    end

    context 'when customer will not be found by phone and added to blacklist' do
      before(:each) { post(:add_to_blacklist, params: { phone: '999-999-9999' }) }

      it 'renders blacklist view with errors' do
        expect(customer.reload.blacklist).to be_falsey
        expect(response.status).to eq(200)
        expect(response).to render_template(:blacklist)
        expect(response.body).to match('Customer was not found by phone: 999-999-9999')
      end
    end
  end

  describe '#new' do
    context 'when new customer form will be created' do
      before(:each) { get(:new) }

      it 'assigns new customer to @customer' do
        expect(assigns(:customer)).to_not be_nil
        expect(assigns(:customer)).to be_a_new(Customer).with(name: nil, phone: nil, description: nil, blacklist: false)
      end

      it 'renders new view' do
        expect(response.status).to eq(200)
        expect(response).to render_template(:new)
        expect(response.body).to match('New Customer')
      end
    end
  end

  describe '#create' do
    context 'when new record will be created' do
      it 'successfully creates new record' do
        expect do
          post(:create, params: { customer: { name: 'Cuurjol', phone: '123-456-7890', description: 'description' } })
        end.to change { Customer.count }.from(0).to(1)
      end

      it 'redirects to index view' do
        post(:create, params: { customer: { name: 'Cuurjol', phone: '123-456-7890', description: 'description' } })
        expect(response.status).to eq(302)
        expect(response).to redirect_to(root_path)
        expect(flash[:success]).to eq('Customer was successfully created.')
      end
    end

    context 'when new record will not be created' do
      it 'renders new view with errors' do
        expect do
          post(:create, params: { customer: { name: 'Cuurjol', phone: '12345678901', description: 'description' } })
        end.to change(Customer, :count).by(0)

        expect(response.status).to eq(200)
        expect(response).to render_template(:new)
        expect(response.body).to match('is invalid')
      end
    end
  end

  describe '#edit' do
    context 'when editing customer form will be created' do
      let!(:customer) do
        FactoryBot.create(:customer, name: 'Cuurjol', phone: '123-456-7890', description: 'description')
      end

      before(:each) { get(:edit, params: { id: customer.id }) }

      it 'assigns customer to @customer' do
        expect(assigns(:customer)).to_not be_nil
        expect(assigns(:customer)).to be_an_instance_of(Customer)
        expect(assigns(:customer)).to have_attributes(name: 'Cuurjol', phone: '123-456-7890',
                                                      description: 'description')
      end

      it 'renders edit view' do
        expect(response.status).to eq(200)
        expect(response).to render_template(:edit)
        expect(response.body).to match('Editing Customer')
      end
    end
  end

  describe '#update' do
    let!(:customer) { FactoryBot.create(:customer) }

    context 'when existing record will be updated' do
      before(:each) do
        put(:update, params: { id: customer.id, customer: { name: 'Cuurjol', phone: '123-456-7890',
                                                            description: 'description' } })
      end

      it 'updates record' do
        expect(customer.reload.name).to eq('Cuurjol')
        expect(customer.reload.phone).to eq('123-456-7890')
        expect(customer.reload.description).to eq('description')
      end

      it 'redirects to index view' do
        expect(response.status).to eq(302)
        expect(response).to redirect_to(root_path)
        expect(flash[:success]).to eq('Customer was successfully updated.')
      end
    end

    context 'when existing record will not be updated' do
      let!(:customer) do
        FactoryBot.create(:customer, name: 'Cuurjol', phone: '123-456-7890', description: 'description')
      end

      before(:each) { put(:update, params: { id: customer.id, customer: { phone: '12345678901'} }) }

      it 'does not update record' do
        expect(customer.reload.phone).to_not eq('12345678901')
      end

      it 'renders edit view' do
        expect(response.status).to eq(200)
        expect(response).to render_template(:edit)
        expect(response.body).to match('Editing Customer')
        expect(response.body).to match('is invalid')
      end
    end
  end

  describe '#destroy' do
    let!(:customer) { FactoryBot.create(:customer) }

    context 'when customer will be destroyed' do
      it 'successfully destroys customer' do
        expect do
          delete(:destroy, params: { id: customer.id })
        end.to change { Customer.count }.from(1).to(0)
      end

      it 'redirects to index view' do
        delete(:destroy, params: { id: customer.id })
        expect(response.status).to eq(302)
        expect(response).to redirect_to(root_path)
        expect(flash[:success]).to eq('Customer was successfully destroyed.')
      end
    end
  end
end
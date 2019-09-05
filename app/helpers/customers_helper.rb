module CustomersHelper
  def customer_actions(customer)
    return link_to('Unban', unban_customer_path(customer), method: :put) if customer.blacklist?

    <<-HTML.html_safe
      #{link_to('Edit', edit_customer_path(customer))}
       |
      #{link_to('Destroy', customer, method: :delete, data: { confirm: 'Are you sure?' })}
       |
      #{link_to('Ban', ban_customer_path(customer), method: :put)}
    HTML
  end

  def customers_list(customers)
    return content_tag(:p, 'Customers not found') if customers.blank?

    render(partial: 'customers/table', locals: { customers: customers })
  end
end

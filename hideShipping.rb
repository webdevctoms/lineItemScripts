found_no_us_ship = false
customer_us = false
customer_not_canada = false

country = Input.cart.shipping_address.country_code
puts "customer country : #{country}"
#every other country code will trigger this for now
if country.upcase != "CA"
  customer_not_canada = true
end
if customer_not_canada
  Input.cart.line_items.each do |line_item|
    product = line_item.variant.product
    puts "#{product.tags}"
    if product.tags.include? '__no-us-ship'
      puts "#{line_item.variant.title} test no shipping to us"
      found_no_us_ship = true
      break
    end
  end
end

Output.shipping_rates = Input.shipping_rates.delete_if {| ship_rate | found_no_us_ship == true}
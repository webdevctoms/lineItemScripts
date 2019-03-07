country = Input.cart&.shipping_address&.country_code
puts "customer country : #{country}"
#every other country code will trigger this for now
if country&.upcase != "CA"
  customer_not_canada = true
end
if customer_not_canada
  Input.cart.line_items.each do |line_item|
    product = line_item.variant.product
    puts "#{product.tags}"
    if product&.tags&.include? '__no-us-ship'
      puts "#{line_item.variant.title} test no shipping to us"
      newProperties = line_item.properties_was
      newProperties["Item does not ship to the United States"] = "Please remove item from your cart"
      line_item.change_properties(newProperties, message: "This Item Does Not Ship to the US")
      #line_item.change_line_price(line_item.line_price_was * 0.99, message: "This Item Does Not Ship to the US")
      puts "after change properties"
    end
  end
end

Output.cart = Input.cart
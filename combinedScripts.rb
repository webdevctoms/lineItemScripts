class NoShipUs
	def initialize(cart)
		@cart = cart
		@country = @cart&.shipping_address&.country_code
		@customer_not_canada = @country&.upcase != "CA" ? true : false
	end
	def run()
		if @customer_not_canada
		  @cart.line_items.each do |line_item|
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
	end
end

class AccountDiscounts
	def initialize(cart,tag)
		@cart = cart
		@discountTag = tag
		@message = tag.upcase + " discount"
	end
	
	def numeric?(num)
	    return Float(num) != nil rescue false
	end

	def run()
		if @cart.customer&.tags&.any? {|tag| tag.downcase.include?(@discountTag)}
			@cart.line_items.each do |line_item|
				product = line_item.variant.product
				currentProductTags = product&.tags
				currentProductTags.each do |tag|
					if tag.include?(@discountTag)
						quantity = line_item.quantity
						trimmedTag = tag.split("__")[1]		
						discountPrice = trimmedTag.split("_")[1]
						if self.numeric?(discountPrice)
	  						newPrice = Money.new(cents: 100) * discountPrice * quantity
	  						line_item.change_line_price(newPrice, message: @message)
						end
					end
				end		
			end	
		end	
	end	
end

class AccountMessage
	def initialize(cart,tag)
		@cart = cart
		@accountTag = tag
		@visibleTag = "__" + tag + "_visible"
	end

	def run()
		if @cart.customer&.tags&.any? {|tag| tag.downcase.include?(@accountTag)}
			return
		else
			@cart.line_items.each do |line_item|
				product = line_item.variant.product
				if product&.tags&.include? @visibleTag
					newProperties = line_item.properties_was
			      	newProperties["Account Not Authorized to Purchase this Item"] = "Please remove item from your cart"
			      	line_item.change_properties(newProperties, message: "Incorrect Account")
				end
			end
		end
	end
end

CAMPAIGNS = [NoShipUs.new(Input.cart),
AccountDiscounts.new(Input.cart,"rcmp"),
AccountMessage.new(Input.cart,'rcmp'),
AccountDiscounts.new(Input.cart,"ems"),
AccountMessage.new(Input.cart,'ems')]

CAMPAIGNS.each do |campaign|
  campaign.run()
end

Output.cart = Input.cart
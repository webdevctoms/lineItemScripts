class AccountMessage
	def initialize(cart,tag)
		@cart = cart
		@accountTag = tag
	end

	def run()
		if @cart.customer&.tags&.any? {|tag| tag.downcase.include?(@accountTag)}
			return
		else
			@cart.line_items.each do |line_item|
				product = line_item.variant.product
				if product&.tags&.include? '__rcmp_visible'
					newProperties = line_item.properties_was
			      	newProperties["Account Not Authorized to Purchase this Item"] = "Please remove item from your cart"
			      	line_item.change_properties(newProperties, message: "Incorrect Account")
				end
			end
		end
	end
end

CAMPAIGNS = [AccountMessage.new(Input.cart,'rcmp')]

CAMPAIGNS.each do |campaign|
  campaign.run()
end

Output.cart = Input.cart
class TiedItems
	def initialize(cart)
		@cart = cart
	end

	def run()
		@cart.line_items.each do |line_item|
			product = line_item.variant.product
			if product&.tags.length > 0
				puts "#{product.tags}"
			end
		end
	end

end

CAMPAIGNS = [TiedItems.new(Input.cart)]

CAMPAIGNS.each do |campaign|
  campaign.run()
end

Output.cart = Input.cart
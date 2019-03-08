class SingleProductDiscount
	def initialize(cart)
		@cart = cart
		@productId = 1860550819940
	end

	def run()
		@cart.line_items.each do |line_item|
		  product = line_item.variant.product
		  next if product.gift_card?
		  next unless product.id == 1860550819940
		  line_item.change_line_price(line_item.line_price * 0.90, message: "My Sale")
		end
	end
end



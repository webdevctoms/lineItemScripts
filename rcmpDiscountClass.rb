class RCMPDiscounts
	def initialize(cart)
		@cart = cart
		@productTags = self.assignTags()
		@discountTag = "rcmp"
		puts "#{@productTags}"
	end

	def assignTags()
		productTags = []
		@cart.line_items.each do |line_item|
			productTags.push("test")
		end
		return productTags
	end

end

CAMPAIGNS = [RCMPDiscounts.new(Input.cart)]
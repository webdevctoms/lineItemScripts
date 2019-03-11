class RCMPDiscounts
	def initialize(cart)
		@cart = cart
		@discountTag = "rcmp"
		@message = "RCMP Discount"
	end

	def run()
		@cart.line_items.each do |line_item|
			product = line_item.variant.product
			currentProductTags = product&.tags
			currentProductTags.each do |tag|
				if tag.include?(@discountTag)
					quantity = line_item.quantity
					trimmedTag = tag.split("__")[1]				
					discountPrice = trimmedTag.split("_")[1]
					newPrice = Money.new(cents: 100) * discountPrice * quantity
					line_item.change_line_price(newPrice, message: @message)
					
				end
			end		
		end		
	end
	
end

CAMPAIGNS = [RCMPDiscounts.new(Input.cart)]

CAMPAIGNS.each do |campaign|
  campaign.run()
end

Output.cart = Input.cart
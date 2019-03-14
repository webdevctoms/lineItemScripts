class RCMPDiscounts
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

CAMPAIGNS = [RCMPDiscounts.new(Input.cart,"rcmp")]

CAMPAIGNS.each do |campaign|
  campaign.run()
end

Output.cart = Input.cart
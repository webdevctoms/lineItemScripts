class TiedItemsMessage
	def initialize(cart)
		@cart = cart
		@productIds = {}
	end

	def captureIds
		@cart.line_items.each do |line_item|
			productId = line_item.variant.product.id.to_s
			@productIds[productId] = productId
		end
	end

	def run()
		captureIds()
		@cart.line_items.each do |line_item|
			product = line_item.variant.product
			if product&.tags.length > 0
				currentProductTags = product&.tags
				currentProductTags.each do |tag|
					if tag.include?("dependent")
						trimmedTag = tag.split("__")[1]		
						dependentId = trimmedTag.split("_")[1]
						if @productIds[dependentId]
							
						else
						    newProperties = line_item.properties_was
							newProperties["This product cannot be purchased without purchasing the related product"] = "Please remove item from your cart"
			      			line_item.change_properties(newProperties, message: "Incorrect Products")
						end
					end
				end	
			end
		end
	end
end

CAMPAIGNS = [TiedItemsMessage.new(Input.cart)]

CAMPAIGNS.each do |campaign|
  campaign.run()
end

Output.cart = Input.cart
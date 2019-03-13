class AccountHideShipping
	def initialize(shipping_rates,cart,tag)
		@shipping_rates = shipping_rates
		@cart = cart
		@accountTag = tag
		@found_hidden_product = false
		@visibleTag = "__" + tag + "_visible"
	end

	def run()
		if @cart.customer&.tags&.any? {|tag| tag.downcase.include?(@accountTag)}
			return
		else
			@cart.line_items.each do |line_item|
				product = line_item.variant.product
				if product&.tags&.include? @visibleTag
					@found_hidden_product = true
		      		@shipping_rates.delete_if {| ship_rate | @found_hidden_product == true}
				end
			end
		end
	end
end


CAMPAIGNS = [AccountHideShipping.new(Input.shipping_rates,Input.cart,'rcmp')]

CAMPAIGNS.each do |campaign|
  campaign.run()
end

Output.shipping_rates = Input.shipping_rates
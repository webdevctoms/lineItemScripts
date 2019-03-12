class AccountHideShipping
	def initialize(shipping_rates,cart)
		@shipping_rates = shipping_rates
		@cart = cart
		@found_hidden_product = false
	end

	def run()
		if @cart.customer&.tags&.any? {|tag| tag.downcase.include?(@accountTag)}
			return
		else
			@cart.line_items.each do |line_item|
				product = line_item.variant.product
				if product&.tags&.include? '__rcmp_visible'
					@found_hidden_product = true
		      		@shipping_rates.delete_if {| ship_rate | @found_hidden_product == true}
				end
			end
		end
	end
end


CAMPAIGNS = [AccountHideShipping.new(Input.shipping_rates,Input.cart)]

CAMPAIGNS.each do |campaign|
  campaign.run()
end

Output.shipping_rates = Input.shipping_rates
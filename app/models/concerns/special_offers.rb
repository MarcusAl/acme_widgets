module SpecialOffers
  extend ActiveSupport::Concern

  included do
    def self.special_offers
      @special_offers ||= load_special_offers
    end

    def self.load_special_offers
      yaml_path = Rails.root.join("config", "special_offers.yml")
      return [] unless File.exist?(yaml_path)

      YAML.load_file(yaml_path).deep_symbolize_keys[:special_offers] || []
    rescue => e
      Rails.logger.error "Failed to load special offers: #{e.message}"
      []
    end
  end

  def special_offers_discount
    apply_special_offers
  end

  def special_offers_discount_formatted
    Money.new(apply_special_offers, "USD").format
  end

  private

  def apply_special_offers
    total_discount = 0

    self.class.special_offers.each do |offer|
      discount = calculate_offer_discount(offer)
      total_discount += discount if discount > 0
    end

    total_discount
  end

  def calculate_offer_discount(offer)
    case offer[:discount_type]
    when "buy_one_get_one_half_price"
      buy_one_get_one_half_price_discount(offer)
    # when 'bulk_discount'
    #   bulk_discount(offer)
    else
      0
    end
  end

  def buy_one_get_one_half_price_discount(offer)
    product_code = offer[:product_code]
    quantity = count_product_quantity(product_code)

    return 0 if quantity < 2

    pairs = quantity / 2
    product_price = find_product_price(product_code)

    # Half price for every second item
    (pairs * product_price / 2).to_i
  end

  def count_product_quantity(product_code)
    # Implement me to return the quantity of a specific product in the cart
    raise NotImplementedError, "count_product_quantity method must be implemented"
  end

  def find_product_price(product_code)
    # Implement me to return the price of a specific product in cents
    raise NotImplementedError, "find_product_price method must be implemented"
  end
end

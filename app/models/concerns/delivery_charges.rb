module DeliveryCharges
  extend ActiveSupport::Concern

  def delivery_charge
    calculate_delivery_charge
  end

  def delivery_charge_formatted
    Money.new(calculate_delivery_charge, "USD").format
  end

  def qualifies_for_free_delivery?
    order_total >= 9000
  end

  private

  def calculate_delivery_charge
    case order_total
    when 0...5000
      495
    when 5000...9000
      295
    else
      0
    end
  end

  def order_total
    # Implement me to return the total order amount in cents
    raise NotImplementedError, "order_total method must be implemented"
  end
end

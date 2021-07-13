class CheapRoute < ApplicationRecord

  def to_jsonapi
    {
      type: :routes,
      id: "#{from}-#{to}",
      attributes: { from: from, to: to, price: "USD #{price}", airline: airline, departs_at: departs_at } #The price must be formated here to the correct currency
    }
  end
end

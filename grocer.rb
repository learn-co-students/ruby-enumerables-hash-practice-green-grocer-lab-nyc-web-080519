def consolidate_cart(cart)
  hash = {}
  cart.each do |item_hash|
    item_hash.each do |name, price_hash|
      if hash[name].nil?
        hash[name] = price_hash.merge({:count => 1})
      else
        hash[name][:count] += 1
      end
    end
  end
  hash
end

# def consolidate_coupons(coupons)
#   hash = {}
#   coupons.each do |c|
#     c.each do |name, price_hash|
#       if hash[name].nil?
#         hash[name] = price_hash.merge({:count => 1})
#       else
#         hash[name][:count] += 1
#       end
#     end
#   end
#   hash
# end

def apply_coupons(cart, coupons)
  coupons.each do |c|
    if cart.keys.include?(c[:item])
      if cart[c[:item]][:count] >= c[:num]
        new_name = "#{c[:item]} W/COUPON"
        if cart[new_name]
          cart[new_name][:count] += c[:num]
        else
          cart[new_name] = {
            count: c[:num],
            price: c[:cost]/c[:num],
            clearance: cart[c[:item]][:clearance]
          }
        end
        cart[c[:item]][:count] -= c[:num]
      end
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |item, price_hash|
    if price_hash[:clearance] == true
      price_hash[:price] = (price_hash[:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(items, coupons)
  cart = consolidate_cart(items)
  cart1 = apply_coupons(cart, coupons)
  cart2 = apply_clearance(cart1)
  
  total = 0
  
  cart2.each do |name, price_hash|
    total += price_hash[:price] * price_hash[:count]
  end
  
  return total unless total > 100 
  return total * 0.9 
  
end
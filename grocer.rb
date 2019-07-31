def consolidate_cart(cart)
  cart.reduce({}) do |cart_hash, item_hash|
    if cart_hash.has_key?(item_hash.keys[0])
      cart_hash[item_hash.keys[0]][:count] += 1
    else
      item_hash[item_hash.keys[0]][:count] = 1
      cart_hash.merge!(item_hash)
    end
    cart_hash
  end
end

def apply_coupons(cart, coupons)
  if coupons.length > 0
    coupons.each do |coupon|
      key = coupon[:item]
      coupon_key = key + " W/COUPON"
      if cart.has_key?(key)
        if cart[key][:count] >= coupon[:num]
          if cart.has_key?(coupon_key)
            cart[key + " W/COUPON"][:count] += coupon[:num]
            cart[key][:count] -= coupon[:num]
          else
            new_item = {
              key + " W/COUPON" => {
                :price => coupon[:cost] / coupon[:num],
                :clearance => cart[key][:clearance],
                :count => coupon[:num]
              }
            }
            cart.merge!(new_item)
            cart[key][:count] -= coupon[:num]
          end
        end
      end
    end
    return cart
  else
    #no coupons in the array
    return cart
  end
end

def apply_clearance(cart)
  cart.each do |key, value|
    if value[:clearance] == true
      discount = (value[:price] * 0.2).round(2)
      value[:price] -= discount
    end
  end
  return cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  cart_w_coupons_applied = apply_coupons(consolidated_cart, coupons)
  cart_w_clearance_applied = apply_clearance(cart_w_coupons_applied)
  total = 0
  consolidated_cart.each do |item|
    total += (item[1][:price] * item[1][:count])
  end
  if total > 100
    total -= (total * 0.1).round(2)
  end
  return total
end

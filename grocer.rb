def consolidate_cart(cart)
  result = {}
  cart.each do |item|
    if result[item.keys[0]]
      result[item.keys[0]][:count] += 1
    else
      result[item.keys[0]] = {
        count: 1,
        price: item.values[0][:price],
        clearance: item.values[0][:clearance]
      }
    end
    
  end
  result
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    if cart.keys.include?(coupon[:item])
      if cart[coupon[:item]][:count] >= coupon[:num]
        new_name = "#{coupon[:item]} W/COUPON"
        if cart[new_name]
          cart[new_name][:count] += coupon[:num]
        else
          cart[new_name] = {
            count: coupon[:num],
            price: coupon[:cost]/coupon[:num],
            clearance: cart[coupon[:item]][:clearance]
          }
        end
        cart[coupon[:item]][:count] -= coupon[:num]
      end
    end
  end
  cart
end

def apply_clearance(cart)
  cart.keys.each do |item|
    if cart[item][:clearance]
      cart[item][:price] = (cart[item][:price]*0.80).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  coupons_applied= apply_coupons(consolidated_cart, coupons)
  discounts_applied = apply_clearance(coupons_applied)

  total = 0.0
  discounts_applied.keys.each do |item|
    total += discounts_applied[item][:price]*discounts_applied[item][:count]
  end
  
  if total > 100.00
    return (total * 0.90).round
  else
    total
  end
end

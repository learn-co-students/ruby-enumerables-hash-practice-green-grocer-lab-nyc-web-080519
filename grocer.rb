def consolidate_cart(cart)
  consolidated_cart = Hash.new
  cart.each do |item|
    item_name = item.keys[0]
    consolidated_item = consolidated_cart[item_name]
    if !consolidated_item
      consolidated_item = item[item_name]
      consolidated_cart[item_name] = consolidated_item
      consolidated_item[:count] = 1
    else
      consolidated_item[:count] += 1
    end
  end
  return consolidated_cart
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    item = cart[coupon[:item]]
    if item && item[:count] >= coupon[:num]
      couponed_item_name = coupon[:item] + " W/COUPON";
      couponed_item = cart[couponed_item_name]
      if !couponed_item
        couponed_item = {:clearance => item[:clearance], :count => 0, :price => coupon[:cost] / coupon[:num]}
        cart[couponed_item_name] = couponed_item
      end
      
      if item[:count] >= coupon[:num]
        couponed_item[:count] += coupon[:num]
        item[:count] -= coupon[:num]
      end
    end
  end
  return cart
end

def apply_clearance(cart)
  cart.each do |item_name, item|
    if item[:clearance]
      item[:price] -= (item[:price] * 0.2).round(2)
    end
  end  
  return cart
end

def checkout(cart, coupons)
  consolidated = consolidate_cart(cart)
  coupons_applied = apply_coupons(consolidated, coupons)
  clearance_applied = apply_clearance(coupons_applied)
  total = 0
  clearance_applied.each do |item_name, item|
    total += item[:price] * item[:count]
  end
  
  if total > 100
    total -= (total * 0.1).round(2)
  end
  return total
end



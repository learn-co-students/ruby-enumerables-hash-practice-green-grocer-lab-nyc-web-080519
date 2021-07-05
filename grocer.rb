def consolidate_cart(cart)
  newcart = {}
  count = 0 
  
  cart.each do |element|
    element.each do |fruit, hash|
      newcart[fruit] ||= hash 
      newcart[fruit][:count] ||= 0 
      newcart[fruit][:count] += 1 
    end
  end
  return newcart
end



  
def apply_coupons(cart, coupons)

    cart_with_coupons = cart
    i = 0
    
    while i < coupons.length do
      use_coupon = nil
      coupons_clearance = nil
      coupons_hash = coupons[i]
      coupons_cost = coupons_hash[:cost]
      coupons_item = coupons_hash[:item]
      coupons_num = coupons_hash[:num]
      item_count = nil
      
      cart.each do |key, value|
          item_count = cart_with_coupons[key][:count]
          if coupons_item == key && cart_with_coupons[key][:count] >= coupons_num
            use_coupon = true
            coupons_clearance = cart[key][:clearance]
            cart_with_coupons[key][:count] -= coupons_num 
          end
      end
      if (use_coupon) && (cart_with_coupons["#{coupons_item} W/COUPON"]) && (item_count >= coupons_num)
        cart_with_coupons["#{coupons_item} W/COUPON"][:count] += coupons_num
      elsif use_coupon 
        cart_with_coupons["#{coupons_item} W/COUPON"] = {:price => (coupons_cost/coupons_num), :clearance => coupons_clearance, :count => coupons_num}
      end
      i += 1
    end
  return cart_with_coupons
end	















def apply_clearance(cart)
 cart.each do |key, value|
   if cart[key][:clearance] == true 
     cart[key][:price] = (cart[key][:price]*0.8).round(2)
   end
 end
end


def checkout(cart, coupons)
  final_cart = apply_clearance(apply_coupons(consolidate_cart(cart), coupons))
  total = 0
  final_cart.each do |key, value|
    total += final_cart[key][:price]*final_cart[key][:count]
  end
  p total > 100? (total *= 0.9).round(2) : total
end 
  
  
  
  
  

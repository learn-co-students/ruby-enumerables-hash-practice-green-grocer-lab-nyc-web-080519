def consolidate_cart(cart)
  compact_cart = {}
  
  cart.each do |element|
    element.each do |item, hash|
      compact_cart[item] ||= hash
      compact_cart[item][:count] ||= 0
      compact_cart[item][:count] += 1
    end
  end
  compact_cart
end
    

def apply_coupons(cart, coupons)
  
  coupons.each do |coupon_hash|
    coupon_hash.each do |att, val|
      name = coupon_hash[:item]
      
      if cart[name] && cart[name][:count] >= coupon_hash[:num]
        
        if cart["#{name} W/COUPON"]
          cart["#{name} W/COUPON"][:count] += coupon_hash[:num]
        else
          cart["#{name} W/COUPON"] = {:price=>(coupon_hash[:cost]/coupon_hash[:num]), :clearance=>cart[name][:clearance], :count=>coupon_hash[:num]}
        end
        
        cart[name][:count] -= coupon_hash[:num]
      end
    end
  end
  cart
end


def apply_clearance(cart)
  cart.each do |name, item_hash|
    if item_hash[:clearance] == true
      item_hash[:price] = (item_hash[:price]*0.8).round(2)
    end
  end
  cart
end


def checkout(cart, coupons)
  organized_cart = consolidate_cart(cart)
  organized_cart_with_coupons = apply_coupons(organized_cart, coupons)
  final_cart = apply_clearance(organized_cart_with_coupons)
  
  total = 0
  final_cart.each do |name, item_hash|
    total += item_hash[:price] * item_hash[:count]
  end
  
  total *= 0.9 if total > 100
  total
end








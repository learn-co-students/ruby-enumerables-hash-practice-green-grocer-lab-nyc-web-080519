require "pry"

def consolidate_cart(cart)
  cart.reduce({}) do |memo, element|
    key = element.keys[0]
    if memo.has_key?(key)
       element[key][:count] += 1
    else
       element[key][:count] = 1
       memo[key]=element.values[0]
    end
    memo
  end
end


=begin
def apply_coupons(cart, coupons)
    coupons.each do |hash|
      if cart.values[0][:clearance] == TRUE
        item = hash[:item]
        cost = hash[:cost]
        num = hash.values[1]
        count = cart[item][:count]
        price = cart.values[0][:price]
     cart["#{item} W/COUPON"] = {}
     cart["#{item} W/COUPON"][:price] = cost / count
     cart["#{item} W/COUPON"][:clearance] = TRUE
     cart[hash[:item]][:count] -= hash[:num]
     end
    end
    return cart
end
=end 



def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    if cart.keys.include? coupon[:item]
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
  con_cart =consolidate_cart(cart)
  con_cart_coupon = apply_coupons(con_cart, coupons)
  con_cart_clearance = apply_clearance(con_cart_coupon)
  
  total = 0 
  
    con_cart_clearance.each do |item|
      total += item[1][:price] * item[1][:count]
    end
    
  if total >= 100
    total = total * 0.90 
  else 
    total
  end
end

def consolidate_cart(cart)
  i = 0
  c = [] 
  cart.each do |item|
    c.push(item.to_a)
  end
  cc = {}
  c.each do |item|
    item[0][1][:count] = c.count(item)
  end
  c = c.uniq 
  
  c.each do |item|
    cc[item[0][0]] = item[0][1]
  end
  return cc
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
      item = coupon[:item]
      cost = coupon[:cost]
      num = coupon[:num]
      if cart.has_key?(item) && cart[item][:count] >= num
        if !cart.has_key?("#{item} W/COUPON")
          cart["#{item} W/COUPON"] = {
            :price => (cost)/(num),
            :clearance => cart[item][:clearance],
            :count => num
          }
          elsif cart.has_key?("#{item} W/COUPON")
          cart["#{item} W/COUPON"][:count] = cart["#{item} W/COUPON"][:count] + num
          
          end
        cart[item][:count] = cart[item][:count] - num
      end
      
    end
  return cart 
  
end

def apply_clearance(cart)
  cart.each do |k, v|
    if v[:clearance] == TRUE
      price = v[:price]-(v[:price]*0.2)
      v[:price] = price.round(1)
    end
  end
end

def checkout(cart, coupons)
  sum = 0
  cc = consolidate_cart(cart)
  apply_coupons(cc, coupons)
  apply_clearance(cc)
  total = []
  cc.each do |k, v|
    total.push(v[:price]*v[:count])
  end
  total.each do |num|
    sum = sum + num
  end
  if sum > 100
     return sum - sum*0.1
  end
  return sum 
end

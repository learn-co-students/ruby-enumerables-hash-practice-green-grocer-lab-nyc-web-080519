def consolidate_cart(cart)
  # code here
  #changes hashes within the array to arrays, so we have an array of arrays
  #newCart = cart.map{ |item| item.to_a.flatten }
  #adds a count key with value of 1 to each hash
  #newCart.map{ |item| item[1][:count]=1}
  #sort arrays within array based on the first index, which is the ingredient name
  #sortedCart = newCart.sort
  #count = 0
  #while count < sortedCart.length do
    #if only one element in array, or element is the last item, we don't want to look at the next one
    #if count != sortedCart.length - 1
      #if the first element in the array is the same as the first element in the next array,
      #we need to increment the count and remove the dupe
      #if sortedCart[count][0] == sortedCart[count+1][0]
      #  sortedCart[count][1][:count] += 1
      #  sortedCart.delete_at(count+1)
      #end
    #end
    #count += 1
  #end
  #changes the arrays within the array to hashes
  #sortedCart.to_h

  #new and improved with only enumerables and blocks
  cartHash = {}
  cart.each do |item|
    item.each do |name, info|
      if cartHash[name]
        cartHash[name][:count] += 1
      else
        cartHash[name] = info
        cartHash[name][:count] = 1
      end
    end
  end
  cartHash
end

def apply_coupons(cart, coupons)
  # code here
  cartCoupons = {}
  cart.each do |name, info|
    coupons.each do |coupon|
      #if there is a coupon for an item in our cart
      if coupon[:item] == name
        #check if we have enough of the item
        if info[:count] >= coupon[:num]
          #calculate price for one item - divide cost by num
          costPerOne = coupon[:cost] / coupon[:num]
          #reduce regular item count based on coupon num
          info[:count] -= coupon[:num]
          #if we already have an item with coupon, add num from new coupon to it
          if cartCoupons["#{name} W/COUPON"]
            cartCoupons["#{name} W/COUPON"][:count] += coupon[:num]
          #otherwise add new key w/ coupon in name where price is coupon price per single item
          else
            cartCoupons["#{name} W/COUPON"] = {:price => costPerOne, :clearance => info[:clearance], :count => coupon[:num]}
          end
        end
      end
    end
    cartCoupons[name] = info
  end
  cartCoupons
end

def apply_clearance(cart)
  # code here
  cartClearance = {}
  cart.each do |name, info|
    #if clearance is true, lower price 20% and keep clearance and count the same
    if info[:clearance]
      cartClearance[name] = {:price => (info[:price] * 0.8).round(2), :clearance => info[:clearance], :count => info[:count]}
    #otherwise, keep same info
    else
      cartClearance[name] = info
    end
  end
  cartClearance
end

def checkout(cart, coupons)
  # code here
  consolidatedCart = consolidate_cart(cart)
  couponCart = apply_coupons(consolidatedCart, coupons)
  clearanceCart = apply_clearance(couponCart)
  total = 0
  clearanceCart.each do |name, info|
    #need to multiply price by count, since price is per 1 item
    total += (info[:price] * info[:count])
  end
  #if greater than $100, take an additional 10% off
  if total > 100
    total = (total * 0.9).round(2)
  end
  total
end

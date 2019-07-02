require 'pry'
def consolidate_cart(cart)
  consolidated = Hash.new(0)
  cart.each do |element| 
    item = element.keys[0]
    if consolidated.include?(item)
      consolidated[item][:count] += 1
    else
      details = element[item]
      details[:count] = 1
      consolidated.merge!(element)
    end
  end
  puts consolidated
end

array = [
  {"AVOCADO" => {:price => 3.00, :clearance => true }},
  {"AVOCADO" => {:price => 3.00, :clearance => true }},
  {"KALE"    => {:price => 3.00, :clearance => false}}
]

consolidate_cart(array)

hash = {"BEER" => {:price => 13.00, :clearance => false, :count => 3},
 "BEETS" => {:price => 2.50, :clearance => false, :count => 1}}
 
coupon = [{:item=>"AVOCADO", :num=>2, :cost=>5.0}]

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    if cart.keys.include?(coupon[:item])
      item_name = coupon[:item]
      new_item_name = "#{item_name} W/COUPON"
      if cart.key?(new_item_name)
        cart[new_item_name][:count] += coupon[:num]
      else
          cart[new_item_name] = {
          count: coupon[:num],
          price: coupon[:cost] / coupon[:num],
          clearance: cart[item_name][:clearance]
        }
      end
      cart[item_name][:count] -= coupon[:num]
    end
  end
  puts cart
end

apply_coupons(hash, coupon)

def apply_clearance(cart)
  cart.each do |element|
    item_name = element[0]
    if cart[item_name][:clearance]
      cart[item_name][:price] = (cart[item_name][:price] * 0.80).round(2)
    end
  end
end

def checkout(cart, coupons)
  consolidated = consolidate_cart(cart)
  coupons_cart = apply_coupons(consolidated, coupons)
  clearance_cart = apply_clearance(coupons_cart)
  sum = 0
  clearance_cart.each do |element|
    item_name = element[0]
    sum += element[1][:price]
  end
  if sum > 100
    sum = sum * 0.90
  end
  sum
end

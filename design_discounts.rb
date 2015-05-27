 #
 # Product abstract model
 #
 class Product
     attr_accessor :name, :key, :price
     
     def initialize(name, key, price)
         @name = name
         @key = key
         @price = price
     end
 end
 
 #
 # Checkout class implementation
 #
 class Checkout
    attr_accessor :order_items, :total
    
    def initialize(*args)
        @order_items = args
    end
    
    def total
      @total ||= @order_items.map { |val| val.price }.inject(:+)
      @total
    end
    
    def scan(item_code)
        return unless item_code
        DiscountsManager.apply_discount(item_code, self) if DiscountsManager.is_supported_code?(item_code)
    end
    
 end
 
 #
 # All discount parent class
 #
 class DiscountBase
    attr_accessor :products
    
    def initialize(products)
        @products = products
    end
    
    def recalc_with_discount
        raise "Should be overrided!"
    end
 end
 
 #
 # Concrete discount implementation (FR)
 #
 class FrDiscount < DiscountBase
    #
    # Every second product is free 
    #
    PRODUCTS_NUM = 2
    DISCOUNT_PRICE = 0.00
    KEY_TO_FIND = 'FR'
    
    def recalc_with_discount
        return unless self.products
        num = 0
        self.products.each do |product|
            num += 1 if product.key == KEY_TO_FIND
            if num == PRODUCTS_NUM
                product.price = DISCOUNT_PRICE
                num = 0
            end
        end
    end
    
 end
 
 #
 # Concrete discount implementation (SR)
 #
 class SrDiscount < DiscountBase
   #
   # Three or more in than discount to 4.50
   #
    PRODUCTS_TOTAL_COUNT = 3
    DISCOUNT_PRICE = 4.50
    KEY_TO_FIND = 'SR'
    
   def recalc_with_discount
        return unless self.products
        total_count = self.products.inject(0) { |count,obj| obj.key == KEY_TO_FIND ? count+1 : count }
       
        if total_count >= PRODUCTS_TOTAL_COUNT
            self.products.each do |product| 
                product.price = DISCOUNT_PRICE if product.key == KEY_TO_FIND
            end
        end
    end
    
 end
 

 #
 # All Discounts manager
 # Contains information about registered discounts and 
 # how to apply each of them
 #
 class DiscountsManager
    def self.all_discounts
        {
         'FR' => FrDiscount,
         'SR' => SrDiscount
        }
    end
    
    def self.is_supported_code?(code)
        all_discounts.keys.include?(code)
    end
    
    def self.apply_discount(code, checkout_instance)
        discount_instance = all_discounts[code].new(checkout_instance.order_items)
        discount_instance.recalc_with_discount
    end
    
 end
 
 

# 
# App begin
# 
fr = Product.new("Fruit Tea", "FR", 3.11)
sr = Product.new("Strawberries", "SR", 5)
cf = Product.new("Coffee", "CF", 11.23)


#
# Create class instance of Checkout class
# INPUT Arguments: products to checkout
# Scan method: check and apply discount
# Total method: calculates total ))
#
co = Checkout.new(fr.clone, sr.clone, fr.clone, cf.clone, fr.clone, cf.clone, fr.clone, fr.clone, fr.clone, sr.clone, sr.clone)
co.scan('FR')
co.scan('SR')
co.scan('CF')
puts co.total.inspect

#
# App end
#
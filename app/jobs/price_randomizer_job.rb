class PriceRandomizerJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Spree::Product.all.each do |p| 
        p.price = ( (rand Math::E..Math::PI)*rand(50) ).round(2)
        p.save
    end
      
  end
end
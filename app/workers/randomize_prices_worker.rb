class RandomizePricesWorker
  include Sidekiq::Worker
  sidekiq_options :queue => :default , :retry => 1
    
  def perform(*args)
    Spree::Product.all.each do |p| 
        p.price = ( (rand Math::E..Math::PI)*rand(50) ).round(2)
        p.save
    end
      
  end
end

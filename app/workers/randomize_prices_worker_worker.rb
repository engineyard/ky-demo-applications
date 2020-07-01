class RandomizePricesWorkerWorker
  include Sidekiq::Worker

  def perform(h,products_count)
    # Do something
    info = JSON.load(h.to_json)
    info.each do |p| 
        p.Spree::Product.find(p["product_id"])
        p.price = ( (rand Math::E..Math::PI)*rand(50) ).round(2)
        p.save
    end
      
  end
end

class PriceRandomizerJob < ApplicationJob
  queue_as :default

  def perform(*args)
    h = []
    Spree::Product.all.each do |p| 
        h << {"product_id" => p.id, "price" => ( (rand Math::E..Math::PI)*rand(50) ).round(2) }
    end
      
    RandomizePricesWorkerWorker.perform_async(h.to_json, h.count)
      
  end
end
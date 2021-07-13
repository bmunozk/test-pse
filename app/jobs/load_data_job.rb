# Loads all routes 
class LoadDataJob < ApplicationJob
  queue_as :default

  AIRPORT_CODES = %w[UIO SCL MDZ LIM ZAL PMC LSC EZE GRU].freeze #Its added the following destinations la serena, buenos aires and sao paulo
  def perform
    AIRPORT_CODES.each do |from|
      AIRPORT_CODES.each do |to|
        LoadRouteJob.set(wait: 1.minutes).perform_later(from, to)
      end
    end
  end
end

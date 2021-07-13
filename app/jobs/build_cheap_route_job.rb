# Builds the cheapest route possible between all nodes
class BuildCheapRouteJob < ApplicationJob
  queue_as :default

  def perform
    uc = UseCases::BuildCheapRoute.new()
    return unless uc.valid?

    uc.execute
  end
end

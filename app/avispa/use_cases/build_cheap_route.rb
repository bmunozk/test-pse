module UseCases
  # Shows the cheapest alternative for every origin
  class BuildCheapRoute < Base
  
    def run_validations; end

    def prepare
      @routes = ::RouteOption.in(6.hours)
      @origins = @routes.distinct(:from).pluck(:from)
      @destinations = @routes.distinct(:to).pluck(:to)
      @airlines = @routes.distinct(:airline_ref).pluck(:airline_ref)
      @travel_mtx = {}
    end

    def run
      possible_routes.each do |from, to, airline_ref|
        leg = @routes.origin(from).destination(to).airline(airline_ref).cheaper.first
        @travel_mtx["#{airline_ref}: #{from}->#{to}"] = leg
      end

      @travel_mtx.each_value do |leg|
        ::CheapRoute.create(from: leg.from, to: leg.to, price: leg.price, 
                            airline: leg.airline_ref, departs_at: leg.departs_at) #It was missing the departs date
      end
    end

    def possible_routes
      routes = []
      @origins.each do |from|
        @destinations.each do |to|
          @airlines.each do |airline_ref|
            routes << [from, to, airline_ref] if valid_tuple? from, to, airline_ref
          end  
        end
      end
      routes
    end

    def valid_tuple?(from, to, airline_ref)
      @routes.where(from: from, to: to, airline_ref: airline_ref).present?
    end
  end
end

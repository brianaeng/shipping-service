require 'active_shipping'

class EstimatesController < ApplicationController

  #User should be able to get shipping quotes for different delivery types (standard, express, overnight)
  #Users should get cost comparisons between two or more carriers
  #When a user's request is incomplete, return an error
  #When a user's request does not process in a timely manner, return an error
  #Users requests should be logged so that responses could be audited

  def index
    #This will get all estimates from shipping providers
    package = ActiveShipping::Package.new(params[:weight].to_i, [15, 10, 4.5])

    origin = ActiveShipping::Location.new(country: 'US', state: 'WA', city: 'Seattle', zip: '98161')

    destination = ActiveShipping::Location.new(country: 'US', state: params[:state].to_s, city: params[:city].to_s, postal_code: params[:zip].to_s)

    estimates = []

    #UPS ESTIMATES
    ups = ActiveShipping::UPS.new(login: 'auntjudy', password: 'secret', key: 'xml-access-key')
    response = ups.find_rates(origin, destination, package)
    ups_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    estimate.push(Estimate.new("UPS", ups_rates))

    #USPS ESTIMATES
    usps = ActiveShipping::USPS.new(login: 'developer-key')
    response = usps.find_rates(origin, destination, package)
    usps_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
    estimate.push(Estimate.new("USPS", usps_rates))

    if estimates == []
      render :json => [], :status => :no_content
    else
      render :json => estimates, :status => :ok
    end
  end
end

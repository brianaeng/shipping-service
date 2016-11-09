require 'active_shipping'

class EstimatesController < ApplicationController

  #User should be able to get shipping quotes for different delivery types (standard, express, overnight)
  #Users should get cost comparisons between two or more carriers
  #When a user's request is incomplete, return an error
  #When a user's request does not process in a timely manner, return an error
  #Users requests should be logged so that responses could be audited


  #Add order ID?

  def shipping_rate
    # if params[:weight] == nil || params[:zip] == nil
    #   render :json => [], :status => :bad_request
    # end
    #This will get all estimates from shipping providers
    package = ActiveShipping::Package.new((params[:weight].to_i * 16), [15, 10, 4.5])

    origin = ActiveShipping::Location.new(country: 'US', zip: '98161')

    #Switching to only zip (can later add state and city if needed)
    destination = ActiveShipping::Location.new(country: 'US', postal_code: params[:zip].to_s)

    #UPS ESTIMATE
    if params[:service_id].upcase == "UPS"
      ups = ActiveShipping::UPS.new(login: ENV["ACTIVESHIPPING_UPS_LOGIN"], password: ENV["ACTIVESHIPPING_UPS_PASSWORD"], key: ENV["ACTIVESHIPPING_UPS_KEY"])
      response = ups.find_rates(origin, destination, package)
      ups_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
      estimate = Estimate.create(name: "UPS", costs: ups_rates)
    #USPS ESTIMATE
    elsif params[:service_id].upcase == "USPS"
      usps = ActiveShipping::USPS.new(login: ENV["ACTIVESHIPPING_USPS_LOGIN"])
      response = usps.find_rates(origin, destination, package)
      usps_rates = response.rates.sort_by(&:price).collect {|rate| [rate.service_name, rate.price]}
      estimate = Estimate.create(name: "USPS", costs: usps_rates)
    end

    #Passes the estimates as json
    # if estimate != nil
      render :json => estimate, :status => :ok
    # else
    #   render :json => estimate.errors, :status => :no_content
    # end
  end

  def requests_log
    logs = Estimate.all

    # if log != nil
      render :json => logs.as_json(), :status => :ok
    # else
    #   render :json => [], :status => :no_content
    # end
  end
end

require 'rubygems'
require 'virtus'
require 'addressable'
require 'json'
require 'date'

module Pvwatts
  class Client
    def initialize(api_key)
      @api_key = api_key
    end

    def simulate(system: system)
      raise(ArgumentError, system.inspect) unless system && system.valid?

      response = Net::HTTP.get('developer.nrel.gov', "/api/pvwatts/v5.json?api_key=#{@api_key}&#{system.to_param}")

      Pvwatts::SimulationEstimate.new(
        JSON.parse(response)
      )
    end
  end

  class Output
    include Virtus.model

    attribute :ac_monthly, Array[Float]
    attribute :poa_monthly, Array[Float]
    attribute :solrad_monthly, Array[Float]
    attribute :dc_monthly, Array[Float]
    attribute :ac_annual, Float
    attribute :solrad_annual, Float

    def ac_monthly
      monthly_hash_for super
    end

    def dc_monthly
      monthly_hash_for super
    end

    def solrad_monthly
      monthly_hash_for super
    end

    def poa_monthly
      monthly_hash_for super
    end

    private

    def monthly_hash_for(values)
      {}.tap do |months|
        Date::MONTHNAMES.compact.each_with_index do |element, index|
          months[element.downcase.to_sym] = values[index]
        end
      end
    end
  end

  class Station
    include Virtus.model

    attribute :latitude, Float
    attribute :longitude, Float
    attribute :elevation, Integer
    attribute :timezone, Integer
    attribute :location, String
    attribute :city, String
    attribute :state, String
    attribute :solar_resource_file, String
    attribute :distance, Integer
  end

  class System
    include Virtus.model

    attribute :system_capacity, Float
    attribute :module_type, Integer
    attribute :losses, Float
    attribute :array_type, Integer
    attribute :tilt, Float
    attribute :azimuth, Float
    attribute :address, String
    attribute :lat, Float
    attribute :lon, Float
    attribute :file_id, String

    def valid?
      all_required_attributes?
    end

    def error_message
      "Missing required attributes: #{attributes.select{|k,v| v.nil?}.keys}. Please see https://developer.nrel.gov/docs/solar/pvwatts-v5/ for API request parameter documentation." unless valid?
    end

    def to_param
      Addressable::URI.new(query_values: attributes).query
    end

    private

    def all_required_attributes?
      !required_attributes.include?(nil)
    end

    def required_attributes
      [
        system_capacity,
        module_type,
        losses,
        array_type,
        tilt,
        azimuth
      ] + relevant_location_attributes
    end

    def relevant_location_attributes
      return [lat, lon] if lat && lon && !file_id && !address
      return [file_id] if !lat && !lon && !address
      return [address] if !lat && !lon && !file_id
    end
  end

  class SimulationEstimate
    include Virtus.model

    attribute :inputs, System
    attribute :errors, Array[String]
    attribute :warnings, Array[String]
    attribute :version, String
    attribute :ssc_info, Hash
    attribute :station_info, Station
    attribute :outputs, Output
  end
end

require 'spec_helper'

describe Pvwatts::Client do
  describe "#simulate" do
    context "when the Pvwatts::System is invalid" do
      it "raises an argument error" do
        system = instance_double("Pvwatts::System", valid?: false)

        expect {
          Pvwatts::Client.new(PVWATTS_SPEC_KEY).simulate(system: system)
        }.to raise_error(ArgumentError)
      end
    end

    context "when the Pvwatts::System is missing" do
      it "raises an argument error" do
        expect {
          Pvwatts::Client.new(PVWATTS_SPEC_KEY).simulate
        }.to raise_error(ArgumentError)
      end
    end

    context "when the Pvwatts::System is valid" do
      let(:valid_system) {
        Pvwatts::System.new(
          system_capacity: 4,
          module_type: 1,
          losses: 10,
          array_type: 1,
          tilt: 40,
          azimuth: 180,
          lat: 40,
          lon: -105
        )
      }

      it "returns a SimulationEstimate" do
        VCR.use_cassette('nrel_example_response') do
          simulation_estimate = Pvwatts::Client.new(PVWATTS_SPEC_KEY).simulate(system: valid_system)
          expect(simulation_estimate).to be_a Pvwatts::SimulationEstimate
        end
      end
    end
  end
end

describe Pvwatts::System do
  let(:valid_system) {
    Pvwatts::System.new(
      system_capacity: 4,
      module_type: 1,
      losses: 10,
      array_type: 1,
      tilt: 40,
      azimuth: 180,
      lat: 40,
      lon: -105
    )
  }
  let(:invalid_system) {
    Pvwatts::System.new(
      system_capacity: 4,
      module_type: 1,
      losses: 10,
      array_type: 1,
      tilt: 40,
      azimuth: 180
    )
  }

  describe "#valid?" do
    it "returns true if all required request attributes are present" do
      expect(valid_system).to be_valid
    end

    it "returns false if at least one required request attribute is not present" do
      expect(invalid_system).to_not be_valid
    end
  end

  describe "#error_message" do
    it "returns nil for a valid system" do
      expect(valid_system.error_message).to be_nil
    end

    it "returns the list of missing attributes and a link to the documentation for an invalid system" do
      expect(invalid_system.error_message).to eq("Missing required attributes: [:address, :lat, :lon, :file_id]. Please see https://developer.nrel.gov/docs/solar/pvwatts-v5/ for API request parameter documentation.")
    end
  end

  describe "#to_param" do
    it "serializes system attributes in query param" do
      expect(valid_system.to_param).to eq("address&array_type=1&azimuth=180.0&file_id&lat=40.0&lon=-105.0&losses=10.0&module_type=1&system_capacity=4.0&tilt=40.0")
    end
  end
end

describe Pvwatts::SimulationEstimate do
  let(:valid_system) {
    Pvwatts::System.new(
      system_capacity: 4,
      module_type: 1,
      losses: 10,
      array_type: 1,
      tilt: 40,
      azimuth: 180,
      lat: 40,
      lon: -105
    )
  }

  it "maps the system section of the NREL JSON response into a Pvwatts::System" do
    VCR.use_cassette('nrel_example_response') do
      simulation_estimate = Pvwatts::Client.new(PVWATTS_SPEC_KEY).simulate(system: valid_system)
      expect(simulation_estimate.inputs).to be_a Pvwatts::System
    end
  end

  it "maps the station_info section of the NREL JSON response into a Pvwatts::Station" do
    VCR.use_cassette('nrel_example_response') do
      simulation_estimate = Pvwatts::Client.new(PVWATTS_SPEC_KEY).simulate(system: valid_system)
      expect(simulation_estimate.station_info).to be_a Pvwatts::Station
    end
  end

  it "maps the outputs section of the NREL JSON response into a Pvwatts::Output" do
    VCR.use_cassette('nrel_example_response') do
      simulation_estimate = Pvwatts::Client.new(PVWATTS_SPEC_KEY).simulate(system: valid_system)
      expect(simulation_estimate.outputs).to be_a Pvwatts::Output
    end
  end
end

describe Pvwatts::Output do
  let(:valid_system) {
    Pvwatts::System.new(
      system_capacity: 4,
      module_type: 1,
      losses: 10,
      array_type: 1,
      tilt: 40,
      azimuth: 180,
      lat: 40,
      lon: -105
    )
  }

  it "maps the output section of the NREL JSON response into an Array of Floats" do
    VCR.use_cassette('nrel_example_response') do
      simulation_estimate = Pvwatts::Client.new(PVWATTS_SPEC_KEY).simulate(system: valid_system)
      output = simulation_estimate.outputs

      expect(output.ac_annual).to eql(6661.72900390625)
    end
  end

  describe "#ac_monthly" do
    it "returns a hash with month name keys and their values" do
      VCR.use_cassette('nrel_example_response') do
        simulation_estimate = Pvwatts::Client.new(PVWATTS_SPEC_KEY).simulate(system: valid_system)
        output = simulation_estimate.outputs

        expect(output.ac_monthly.first).to eql([:january, 474.1012878417969])
      end
    end
  end

  describe "#dc_monthly" do
    it "returns a hash with month name keys and their values" do
      VCR.use_cassette('nrel_example_response') do
        simulation_estimate = Pvwatts::Client.new(PVWATTS_SPEC_KEY).simulate(system: valid_system)
        output = simulation_estimate.outputs

        expect(output.dc_monthly.first).to eql([:january, 494.8523254394531])
      end
    end
  end

  describe "#solrad_monthly" do
    it "returns a hash with month name keys and their values" do
      VCR.use_cassette('nrel_example_response') do
        simulation_estimate = Pvwatts::Client.new(PVWATTS_SPEC_KEY).simulate(system: valid_system)
        output = simulation_estimate.outputs

        expect(output.solrad_monthly.first).to eql([:january, 4.388420581817627])
      end
    end
  end

  describe "#poa_monthly" do
    it "returns a hash with month name keys and their values" do
      VCR.use_cassette('nrel_example_response') do
        simulation_estimate = Pvwatts::Client.new(PVWATTS_SPEC_KEY).simulate(system: valid_system)
        output = simulation_estimate.outputs

        expect(output.poa_monthly.first).to eql([:january, 136.04103088378906])
      end
    end
  end
end

require 'pry'
require 'rspec'
require 'vcr'
require 'webmock/rspec'

require 'pvwatts'


# Set this constant to run the tests
PVWATTS_SPEC_KEY = nil
if PVWATTS_SPEC_KEY.nil?
  raise 'You first need to set the PVWATTS_SPEC_KEY constant in spec_helper.rb'
end

RSpec.configure do |config|; end

VCR.configure do |config|
  config.cassette_library_dir = "spec/cassettes"
  config.hook_into :webmock
end

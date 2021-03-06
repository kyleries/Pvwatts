# pvwatts

Wrapper around the [PVWatts (Version 5) web service API](https://developer.nrel.gov/docs/solar/pvwatts-v5/) which calculates the Performance of a Grid-Connected PV System.

# Installation

`gem install pvwatts`

# Usage

```ruby
  require 'pvwatts'

  # Define a system to simulate
  my_system = Pvwatts::System.new(
    system_capacity: 4,
    module_type: 1,
    losses: 10,
    array_type: 1,
    tilt: 40,
    azimuth: 180,
    lat: 40,
    lon: -105
  )

  # Instantiate a Pvwatts::Client with your NREL api key. To obtain a key,
  # signup here: https://developer.nrel.gov/signup/

  client = Pvwatts::Client.new('YOUR_KEY_HERE')

  # Simulate the solar production of your system

  simulation_estimate = client.simulate(system: my_system)

  # Inspect the simulated output of your system

  my_output = simulation_estimate.outputs

  # Drill down to more specific output data

  my_output.ac_monthly[:january] # => 474.1012878417969
```

## Contributing to pvwatts

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 Solar Universe, LLC. See LICENSE.txt for further details.

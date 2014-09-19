require_relative 'helpers/runner'
require_relative '../../lib/location_data_generator'

describe 'location data generator' do
  it 'should provide talks grouped by locations for a day' do
    days = [
      {
        "name" => 'Day 1',
        "slots" => [
          {
            "talks" => [
              {
                "speaker" => "Peter",
                "location" => "R1",
                "title" => "Title 1"
              },
              {
                "speaker" => "Hans",
                "location" => "R1",
                "title" => "Title 2"
              },

              {
                "speaker" => "Hans",
                "location" => "R144",
                "title" => "DBDGdfgd"
              }
            ]
          },
          {
            "talks" => [
              {
                "speaker" => "Peter",
                "location" => "R1",
                "title" => "Title Foo"
              }
            ]
          }
        ]
      }]

    location_data_generator = RapidSchedule::LocationDataGenerator.new(days)
    location_data = location_data_generator.talks_for_location_for_day 'R1', 'name' => 'Day 1'

    expect(location_data.length).to eq(3)


    expect(location_data[0]['title']).to eq("Title 1")
    expect(location_data[2]['title']).to eq("Title Foo")
  end

  it 'should contain the slot time in location data' do
    days = [
      {
        "name" => 'Day 1',
        "slots" => [
          {
            "start" => '12:00',
            "end" => '23:00',
            "talks" => [
              {
                "speaker" => "Peter",
                "location" => "R1",
                "title" => "Title 1"
              }
            ]
          }
        ]
      }]

    location_data_generator = RapidSchedule::LocationDataGenerator.new(days)
    location_data = location_data_generator.talks_for_location_for_day 'R1', 'name' => 'Day 1'

    expect(location_data[0]["start"]).to eq('12:00')
    expect(location_data[0]["end"]).to eq('23:00')
  end

  it 'provides a list with locations for day' do
    days = [
      {
        "name" => 'Day 1',
        "slots" => [
          {
            "talks" => [
              {
                "location" => "R1",
              },
              {
                "location" => "R5",
              },
              {
                "location" => "R1",
              }
            ]
          },
          {
            "talks" => [
              {
                "location" => "R2",
              },
              {
                "location" => "R1",
              }
            ]
          }
        ]
      }]

    location_data_generator = RapidSchedule::LocationDataGenerator.new(days)
    locations = location_data_generator.locations_for_day('name' => 'Day 1')

    # added in order found, doubles removed
    expect(locations).to eq(['R1', 'R5', 'R2'])
  end
end
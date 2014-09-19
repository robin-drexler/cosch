module RapidSchedule
  class LocationDataGenerator
    def initialize(days)
      @days = days
    end

    def talks_for_location_for_day(location, day)
      day = day_by_name(day["name"])
      talks_at_location = []

      day['slots'].each do |slot|
        slot['talks'].each do |talk|
          if talk["location"] === location
            talk["start"] = slot["start"]
            talk["end"] = slot["end"]

            talks_at_location << talk

          end
        end
      end
      talks_at_location
    end

    def locations_for_day(day)
      day = day_by_name(day["name"])
      locations = []

      day['slots'].each do |slot|
        slot['talks'].each do |talk|
          locations << talk['location'] unless locations.include?(talk['location'])
        end
      end
      locations
    end

    private

    def day_by_name(name)
      @days.each { |day| return day if name === day["name"] }
    end
  end
end
module RapidSchedule
  class Asker
    def self.confirm?(what)
      p what
      p "Ok? [y/n]"
      gets.chomp == 'y'
    end
  end
end
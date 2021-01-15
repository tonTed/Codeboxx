require 'date'
require 'open_weather'

module ElevatorMedia
  class Streamer

    def self.HelloWorld
      return "Hello World"
    end

    def self.GetContent(method, data)
      return temperature(data) if method == "temperature"
      return today(data) if method == "today"
      return advertising(data) if method == "advertising"
    end

    def self.format(inside)
      "<div> #{inside} </div>"
    end

    def self.today(data)
      format(data.strftime("%A, %d %b %Y"))
    end

    def self.temperature(data)
      return format(data) if data.match /^[-]?\d{1,2}[\s][°][C]/
      return "wrong temperature format"
    end

    def self.advertising(data)
      video_extensions = ['.mp4', '.m4p', '.m4v', '.webm']
      return format(data) if data.end_with?(*video_extensions)
      return false
      # return "wrong video format"
    end

  end
end
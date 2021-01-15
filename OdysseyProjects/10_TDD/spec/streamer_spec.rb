require 'elevator_media/streamer'
require 'date'

# Function for format
def format_rspec(data)
  "<div> #{data} </div>"
end

def temperature_rspec(data)
  format_rspec(data)
end

def advertising_rspec(data)
  format_rspec(data)
end

today_rspec = format_rspec(Date.today.strftime("%A, %d %b %Y"))


# Samples
# Temperature
temp_sample1 = "-16 °C"
temp_sample2 = "34 °C"
temp_sample3 = "0 °C"
temp_sample4 = "0 °K"
# Video
adv_sample1 = 'fungo.mp4'
adv_sample2 = 'codeboxx.m4p'
adv_sample3 = 'coveo.m4v'
adv_sample4 = 'cybercat.webm'
adv_sample5 = "cybercat.wkv"

describe ElevatorMedia::Streamer do

  context ".hello_world" do
    it 'print hello world' do
      expect(ElevatorMedia::Streamer.HelloWorld()).to eq("Hello World")
    end
  end

  context ".get_content" do
    it 'return the date of the day format' do
      expect(ElevatorMedia::Streamer.GetContent("today", Date.today)).to eq(today_rspec)
    end

    it 'return the temperature in celsius' do
      # temp_sample1 = "-16 °C"
      # temp_sample2 = "34 °C"
      # temp_sample3 = "0 °C"
      expect(ElevatorMedia::Streamer.GetContent("temperature", temp_sample1)).to eq(temperature_rspec(temp_sample1))
      expect(ElevatorMedia::Streamer.GetContent("temperature", temp_sample2)).to eq(temperature_rspec(temp_sample2))
      expect(ElevatorMedia::Streamer.GetContent("temperature", temp_sample3)).to eq(temperature_rspec(temp_sample3))
      expect(ElevatorMedia::Streamer.GetContent("temperature", temp_sample4)).to eq("wrong temperature format")
    end

    it 'return an extract advertising video' do
      # adv_sample1 = 'fungo.mp4'
      # adv_sample2 = 'codeboxx.m4p'
      # adv_sample3 = 'coveo.m4v'
      # adv_sample4 = 'cybercat.webm'
      # adv_sample5 = "cybercat.wkv"
      expect(ElevatorMedia::Streamer.GetContent("advertising", adv_sample1)).to eq(advertising_rspec(adv_sample1))
      expect(ElevatorMedia::Streamer.GetContent("advertising", adv_sample2)).to eq(advertising_rspec(adv_sample2))
      expect(ElevatorMedia::Streamer.GetContent("advertising", adv_sample3)).to eq(advertising_rspec(adv_sample3))
      expect(ElevatorMedia::Streamer.GetContent("advertising", adv_sample4)).to eq(advertising_rspec(adv_sample4))
      expect(ElevatorMedia::Streamer.GetContent("advertising", adv_sample5)).to be_falsey
    end
  end
end


# Week 10 - Quality and TDD

https://tonted.xyz/

## Summary
- [Steps Install](#steps-install)
- [ElevatorMedia and Streamer](#elevatornedia-and-streamer)
- [Three unit tests ](#three-unit-tests)
- [Links & Access](#links-and-access)
- [Sources](#sources)

## Steps Install
#### Install gem rspec:
Source : https://github.com/rspec/rspec-rails

#### Other gems:
https://github.com/guard/guard-rspec
https://github.com/thoughtbot/factory_bot

#### Other tips:
After install the gem rspec, you scan generate rspec files with the cmd :
```shell script
rails generate rspec:model user
rails generate rspec:controller user

etc...
```
And if you scaffold something the rpec files will be generated automatically.

## ElevatorMedia and Streamer
#### Refactoring method for format
```ruby
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
```

#### Samples
```ruby
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
```    

#### First media : Date
```ruby
 it 'return the date of the day format' do
      expect(ElevatorMedia::Streamer.GetContent("today", Date.today)).to eq(today_rspec)
 end
```

#### Second media : Temperature
```ruby
it 'return the temperature in celsius' do
      expect(ElevatorMedia::Streamer.GetContent("temperature", temp_sample1)).to eq(temperature_rspec(temp_sample1))
      expect(ElevatorMedia::Streamer.GetContent("temperature", temp_sample2)).to eq(temperature_rspec(temp_sample2))
      expect(ElevatorMedia::Streamer.GetContent("temperature", temp_sample3)).to eq(temperature_rspec(temp_sample3))
      expect(ElevatorMedia::Streamer.GetContent("temperature", temp_sample4)).to eq("wrong temperature format")
    end
```

#### Third media : Video
```ruby
    it 'return an extract advertising video' do
      expect(ElevatorMedia::Streamer.GetContent("advertising", adv_sample1)).to eq(advertising_rspec(adv_sample1))
      expect(ElevatorMedia::Streamer.GetContent("advertising", adv_sample2)).to eq(advertising_rspec(adv_sample2))
      expect(ElevatorMedia::Streamer.GetContent("advertising", adv_sample3)).to eq(advertising_rspec(adv_sample3))
      expect(ElevatorMedia::Streamer.GetContent("advertising", adv_sample4)).to eq(advertising_rspec(adv_sample4))
      expect(ElevatorMedia::Streamer.GetContent("advertising", adv_sample5)).to be_falsey
    end
```


## Three unit tests
#### User Model
We check if the role after create is well added.
```ruby
RSpec.describe User, type: :model do
  before(:all) do
    @u = User.new(email: 'yddetcoblan@gmail.com', password: 'password')
  end
  context '.assign_default_role' do
    it 'before create is false' do
      expect(@u.has_role? :signup).to be false
      end
    it 'after create is true' do
      @u.save!
      expect(@u.has_role? :signup).to be true
    end
  end
end
```

#### Employee Model
First step:

Using `before` we create an instance for all test.
```ruby
before(:each) do
    @user1 = User.new(:id => 1)
    @employee1 = Employee.new(:first_name => "Teddy", :last_name => "Blanco", :id => 1, :user => @user1, :title => "chouchou")
end
```

Second step: 

We test if the instance of employee is good.
```ruby
  context "test the attributes " do
    it "is valid with valid attributes" do
      expect(@employee1).to be_valid
    end
    it 'check classes of arguments and not nil' do
      expect(@employee1.id.class).to eq Integer
      expect(@employee1.first_name.class).to eq String
      expect(@employee1.last_name.class).to eq String
      expect(@employee1.user_id.class).to eq Integer
      @employee1.first_name.should eql "Teddy"
    end
    it { should belong_to(:user).without_validating_presence }
  end
```

Third step:

We test the method `:full_name`.
```ruby
  context ".full_name" do
    it 'return a string' do
      expect(@employee1.full_name().class).to eq String
    end
    it 'match with format /^[A-Z][a-z]+[ ][A-Z][a-z]+/' do
      expect(@employee1.full_name()).to match(/[A-Z][a-z]+[ ][A-Z][a-z]+/)
    end
  end
```

## Links and Access
### Links

## Sources
https://github.com/rspec/rspec-rails
https://relishapp.com/rspec/rspec-core/v/2-2/docs
https://www.betterspecs.org/
https://rspec.info/

rails generate rspec:model user


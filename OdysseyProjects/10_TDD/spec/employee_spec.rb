require 'rails_helper'

RSpec.describe Employee, type: :model do
  before(:each) do
    @user1 = User.new(:id => 1)
    @employee1 = Employee.new(:first_name => "Teddy", :last_name => "Blanco", :id => 1, :user => @user1, :title => "chouchou")
  end
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
  context ".full_name" do
    it 'return a string' do
      expect(@employee1.full_name().class).to eq String
    end
    it 'match with format /^[A-Z][a-z]+[ ][A-Z][a-z]+/' do
      expect(@employee1.full_name()).to match(/[A-Z][a-z]+[ ][A-Z][a-z]+/)
    end
  end
end


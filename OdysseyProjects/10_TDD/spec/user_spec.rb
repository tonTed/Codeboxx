require 'rails_helper'

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

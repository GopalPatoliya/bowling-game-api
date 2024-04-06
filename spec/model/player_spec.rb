require 'rails_helper'

RSpec.describe Player, type: :model do
  describe 'associations' do
    it { should have_many(:games) }
  end
end

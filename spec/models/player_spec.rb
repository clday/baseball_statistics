require 'rails_helper'

RSpec.describe Player do
  subject { described_class.new(first_name: 'Rafael', last_name: 'Devers') }

  describe '#full_name' do
    it { expect(subject.full_name).to eq("Rafael Devers") }
  end
end

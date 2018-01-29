class Player < ApplicationRecord
  validates :player_id, presence: true, uniqueness: true
  validates :last_name, :first_name, presence: true

  has_many :batting_statistics, primary_key: 'player_id'

  def full_name
    "#{first_name} #{last_name}"
  end
end

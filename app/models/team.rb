class Team < ApplicationRecord
  validates :team_id, :token, presence: true
end

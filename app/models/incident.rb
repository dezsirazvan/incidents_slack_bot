class Incident < ApplicationRecord
  STATUSES = ['open', 'resolved'].freeze

  validates :status, inclusion: { in: STATUSES }
  validates :title, presence: true
end

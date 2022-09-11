class User < ApplicationRecord
  has_secure_password
  has_paper_trail

  enum status: [:active, :archived]

  validates :email,
    presence: true,
    uniqueness: true

  scope :search, -> (search_param) {
    case search_param
    when 'active'
      active
    when 'archived'
      archived
    else
      all
    end
  }
end

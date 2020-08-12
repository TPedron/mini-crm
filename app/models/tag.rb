class Tag < ApplicationRecord
  has_and_belongs_to_many :contacts
  validates :name, uniqueness: true
  before_create :ensure_uuid # NOTE: work around for https://github.com/rails/rails/issues/34237

  private

  def ensure_uuid
    self.uuid ||= SecureRandom.uuid
  end
end

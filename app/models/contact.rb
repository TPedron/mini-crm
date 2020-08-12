class Contact < ApplicationRecord
  validates :first_name, :last_name, :email, presence: true
  before_create :ensure_uuid # NOTE: work around for https://github.com/rails/rails/issues/34237

  private

  def ensure_uuid
    self.uuid ||= SecureRandom.uuid
  end
end

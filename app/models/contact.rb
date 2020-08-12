class Contact < ApplicationRecord
  has_and_belongs_to_many :tags
  validates :first_name, :last_name, presence: true
  validates :email, presence: true, uniqueness: true

  before_create :ensure_uuid # NOTE: work around for https://github.com/rails/rails/issues/34237

  # NOTE: Used for serializing tag names as an attribute
  def tag_names
    tags.pluck(:name)
  end

  private

  def ensure_uuid
    self.uuid ||= SecureRandom.uuid
  end
end

class Api::V1::ContactsController < ApplicationController
  def index
    contacts = contacts_service.list_contacts

    render json: ContactSerializer.new(contacts, is_collection: true), status: :ok
  end

  def create
    contact = contacts_service.create_contact(contact_dto)

    render json: ContactSerializer.new(contact), status: :created
  end

  def update
    contact = contacts_service.find_and_update_contact(contact_dto)

    render json: ContactSerializer.new(contact), status: :ok
  end

  private

  def contacts_service
    @contacts_service ||= ContactsService.new
  end

  def hash_params
    @hash_params ||= params.to_unsafe_h.deep_transform_keys(&:underscore).deep_symbolize_keys
  end

  def contact_dto
    @contact_dto ||= ContactDto.new(hash_params)
  end
end

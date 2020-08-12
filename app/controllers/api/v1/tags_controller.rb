class Api::V1::TagsController < ApplicationController
  def index
    tags = tags_service.list_tags

    render json: TagSerializer.new(tags, is_collection: true), status: :ok
  end

  def create
    tag = tags_service.find_or_create_tag(tag_dto)

    render json: TagSerializer.new(tag), status: :ok
  end

  def update
    tag = tags_service.find_and_update_tag(tag_dto)

    render json: TagSerializer.new(tag), status: :ok
  end

  private

  def tags_service
    @tags_service ||= TagsService.new
  end

  def tag_dto
    @tag_dto ||= TagDto.new(hash_params)
  end
end

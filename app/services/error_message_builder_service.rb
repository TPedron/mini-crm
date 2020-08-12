class ErrorMessageBuilderService
  def self.map_error(error)
    case error
    when ActiveRecord::RecordInvalid
      handle_active_record_error(error.record.errors.to_h)
    end
  end

  private_class_method def self.handle_active_record_error(err)
    errors = []
    err.each do |attr, title|
      errors.push(
        status: 422,
        title: title,
        source: { pointer: "/data/attributes/#{attr.to_s.camelcase(:lower)}" }
      )
    end
    errors
  end
end

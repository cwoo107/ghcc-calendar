json.extract! event, :id, :event_details, :created_at, :updated_at
json.url event_url(event, format: :json)

json.extract! note, :id, :title, :description, :color, :user_id, :files, :created_at, :updated_at
json.url note_url(note, format: :json)
json.files do
  json.array!(note.files) do |file|
    json.id file.id
    json.url url_for(file)
  end
end

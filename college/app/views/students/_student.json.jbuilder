json.extract! student, :id, :registration_number, :name, :branch, :created_at, :updated_at
json.url student_url(student, format: :json)

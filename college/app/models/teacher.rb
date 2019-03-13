class Teacher < ActiveRecord::Base
	# has_attached_file :image
	# validates_attachment :image, presence: true,
	# 					  content_type: { content_type: "image/jpeg" },
	# 					  size: { in: 0..100.kilobytes }
  	has_and_belongs_to_many :students
  	has_many :pictures, as: :imageable, dependent: :destroy
  	accepts_nested_attributes_for :pictures
  	# has_many :subjects
  	# has_many :students, through: :subjects
end

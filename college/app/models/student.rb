class Student < ActiveRecord::Base
	validates :registration_number, presence: true
	validates :name, presence: true
	validates :branch, presence: true
	# has_attached_file :image
	# validates_attachment :image, presence: true,
	# 					  content_type: { content_type: "image/jpeg" },
	# 					  size: { in: 0..100.kilobytes }
	has_and_belongs_to_many :teachers
	has_many :pictures, as: :imageable, dependent: :destroy
	accepts_nested_attributes_for :pictures#, attachment: :file
	# has_many :subjects
	# has_many :teachers, through: :subjects
end

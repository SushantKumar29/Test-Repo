class Student::PicturesController < PicturesController
	before_action :set_imageable
	private
	def set_imageable
		@imageable = Student.find(params[:student_id])
	end
end 
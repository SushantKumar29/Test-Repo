class Teacher::PicturesController < PicturesController
	before_action :set_imageable
	private
	def set_imageable
		@imageable = Teacher.find(params[:teacher_id])
	end
 end
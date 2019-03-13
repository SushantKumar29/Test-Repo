class PicturesController < ApplicationController

	def new
		@picture = Picture.new
	end

	def create
		@picture = @imageable.pictures.new(picture_params)
		@picture.save
		redirect_to @imageable, notice: 'Updated'
	end

	private
	
end	
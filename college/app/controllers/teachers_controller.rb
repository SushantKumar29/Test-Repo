class TeachersController < ApplicationController
  before_action :set_teacher, only: [:show, :edit, :update, :destroy]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  # GET /teachers
  # GET /teachers.json
  def index
    @teachers = Teacher.all.order(name: :ASC).paginate(page: params[:page], per_page: 5)
    render locals: {
      teachers: @teachers
    } 
  end

  # GET /teachers/1
  # GET /teachers/1.json
  def show
    render locals: {
      teacher: Teacher.find_by!(id: params[:id])
    }
  end

  # GET /teachers/new
  def new
    @teacher = Teacher.new
  end

  # GET /teachers/1/edit
  def edit
  end

  # POST /teachers
  # POST /teachers.json
  def create
    @teacher = Teacher.new(teacher_params)

    respond_to do |format|
      if @teacher.save
        
        teacher_picture = @teacher.pictures.new("name" => picture_params)
        teacher_picture.save
        upload

        format.html { redirect_to @teacher, notice: 'Teacher Record is Successfully Created.' }
        format.json { render :show, status: :created, location: @teacher }
      else
        format.html { render :new }
        format.json { render json: @teacher.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /teachers/1
  # PATCH/PUT /teachers/1.json
  def update
    respond_to do |format|
      if @teacher.update(teacher_params)

        imageable = set_teacher
        teacher_picture = imageable.pictures.new(picture_params)
        teacher_picture.save
        upload
        
        format.html { redirect_to @teacher, notice: 'Teacher Record is Successfully Updated.' }
        format.json { render :show, status: :ok, location: @teacher }
      else
        format.html { render :edit }
        format.json { render json: @teacher.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /teachers/1
  # DELETE /teachers/1.json
  def destroy
    @teacher.destroy
    respond_to do |format|
      format.html { redirect_to teachers_url, notice: 'Teacher Record is Successfully Destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_teacher
      @teacher = Teacher.find_by!(params[:id])
    rescue
      record_not_found
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def teacher_params
      params.require(:teacher).permit(:name, :description)
    end

    

    def picture_params
      image = params.require(:teacher).permit(:image)['image'].original_filename
    end

    def upload
      uploaded_io = params[:teacher][:image]
      File.open(Rails.root.join('app','assets','images',uploaded_io.original_filename),'wb') do |file|
        file.write(uploaded_io.read)
      end
    end

    def record_not_found
      render plain: "404 Not Found", status: 404
    end

    
end

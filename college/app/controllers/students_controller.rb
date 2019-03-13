class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update, :destroy, :assign]
  before_action :authenticate_user!, except: [:index, :show]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  
  # GET /students
  # GET /students.json
  def index
    @students = Student.all.order(registration_number: :ASC).paginate(page: params[:page], per_page: 5)
    render locals: {
      students: @students
    } 
  end

  # GET /students/1
  # GET /students/1.json
  def show
    render locals: {
      student: Student.find_by!(id: params[:id])
    }
  end

  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students
  # POST /students.json
  def create
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
        
        student_picture = @student.pictures.new("name" => picture_params)
        student_picture.save
        upload
        format.html { redirect_to @student, notice: 'Student Record is Successfully Created.' }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        
        format.html { redirect_to @student, notice: 'Student Record Is Successfully Updated.' }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @student.destroy
    respond_to do |format|
      format.html { redirect_to students_url, notice: 'Student Record Is Successfully Destroyed.' }
      format.json { head :no_content }
    end
  end

  def assign

    #   @student.teachers << Teacher.find(params[:student][:id])
      # st = assign_teacher
      if(assign_teacher.nil?)
           redirect_to @student, alert: 'Teacher Is Already Assigned To This Student'
      else
          @student_teacher = StudentsTeacher.new(assign_teacher)
          if @student_teacher.save
            redirect_to @student, notice: 'Teacher Is Successfully Assigned To This Student' 
          else
            render 'show'
          end
      end
  end

  def unassign
    StudentsTeacher.where(teacher_id: params['teacher'], student_id: params['id'] ).take.destroy
    respond_to do |format|
      format.html { redirect_to student_path, notice: 'Assignment Is Successfully Removed.' }
    end
    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find_by_id!(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_params
      params.require(:student).permit(:registration_number, :name, :branch)
    end

    def upload
      uploaded_io = params[:student][:image]
      File.open(Rails.root.join('app','assets','images',uploaded_io.original_filename),'wb') do |file|
        file.write(uploaded_io.read)
      end
    end

    def picture_params
      image = params.require(:student).permit(:image)['image'].original_filename
    end

    def assign_teacher
      student_teacher = StudentsTeacher.where(teacher_id: teacher_params, student_id: @student.id ).take
      if student_teacher.nil?
        return {"teacher_id" => teacher_params, "student_id" => @student.id}
      else
        nil
      end
      # byebug
    end

    def teacher_params
      params.require(:student).permit(:id)['id']
      
    end

    def record_not_found
      render plain: "404 Not Found", status: 404
    end

end

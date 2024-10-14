class NotesController < ApplicationController
  before_action :set_note, only: %i[ show edit update destroy ]
  before_action :authenticate_user!

  # GET /notes or /notes.json
  def index
    @notes = current_user.notes
  end

  # GET /notes/1 or /notes/1.json
  def show
    respond_to do |format|
      format.html # renders show.html.erb
      format.json { render json: { visibility: @note.visibility } }
    end
  end

  

  # GET /notes/new
  def new
    @note = current_user.notes.new
  end

  # GET /notes/1/edit
  def edit
    @note = Note.find(params[:id])
  end

  # POST /notes or /notes.json
  def create
    @note = current_user.notes.new(note_params)

    respond_to do |format|
      if @note.save
        format.html { redirect_to @note, notice: "Note was successfully created." }
        format.json { render :show, status: :created, location: @note }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end

  
  # PATCH/PUT /notes/1 or /notes/1.json
  def update
    @note = Note.find(params[:id])
    
    # Append new files to the existing ones
    if note_params[:files].present?
      @note.files.attach(note_params[:files])
    end
  
    if @note.update(note_params.except(:files)) # Update other attributes except files
      redirect_to @note, notice: 'Note was successfully updated.'
    else
      render :edit
    end
  end
  
  # DELETE /notes/1 or /notes/1.json
  def destroy
    @note.destroy!

    respond_to do |format|
      format.html { redirect_to root_path, status: :see_other, notice: "Note was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_note
    @note = current_user.notes.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def note_params
    params.require(:note).permit(:title, :description, :visibility, files: [])
  end
end

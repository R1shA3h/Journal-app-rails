class NotesController < ApplicationController
  before_action :set_note, only: %i[ show edit update destroy share]
  before_action :authenticate_user!

  def index
    @notes = current_user.notes
  end

  def show
    @shared_note = NotePermission.find_by(id: params[:shared_note_id])
    respond_to do |format|
      format.html # renders show.html.erb
      format.json { render json: { visibility: @note.visibility } }
    end
  end

  def new
    @note = current_user.notes.new
  end

  def edit
    @note = Note.find(params[:id])
  end

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


  def update
    @note = Note.find(params[:id])

    # Append new files to the existing ones
    if note_params[:files].present?
      @note.files.attach(note_params[:files])
    end

    if @note.update(note_params.except(:files)) # Update other attributes except files
      redirect_to @note, notice: "Note was successfully updated."
    else
      render :edit
    end
  end

  def share
    # Find the note by the ID passed in the route
    @note = Note.find_by(id: params[:id])

    # Ensure that the note exists
    if @note.nil?
      render json: { error: "Note not found" }, status: :not_found
      return
    end

    # Find user to share with by email
    user_to_share_with = User.find_by(email: params[:recipient_email])
    permission = params[:permission] || "read"

    if user_to_share_with
      # Check if the note is already shared with the user
      existing_permission = NotePermission.find_by(note_id: @note.id, user_id: user_to_share_with.id)

      if existing_permission
        render json: { error: "Note already shared with this user." }, status: :ok
      else
        # Create a new permission record
        @shared_note = NotePermission.create(
          note: @note,
          user: user_to_share_with,
          permission: permission,
          shared_by: current_user.email,
          shared_to: user_to_share_with.email
        )
        render json: { message: "Note shared successfully!" }, status: :ok
      end
    else
      render json: { error: "User not found." }, status: :not_found
    end
  end



  def sharednotes
    sharednote=note.find_by(id: params[:id])
    render json: sharednote, status: :ok
  end



  def destroy
    @note.destroy!

    respond_to do |format|
      format.html { redirect_to root_path, status: :see_other, notice: "Note was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_note
    @note = current_user.notes.find_by(id: params[:id]) ||
            Note.joins(:note_permissions)
                .where(note_permissions: { shared_to: current_user.email })
                .find_by(id: params[:id])
    raise ActiveRecord::RecordNotFound unless @note
  end


  def note_params
    params.require(:note).permit(:title, :description, :visibility, files: [])
  end
end

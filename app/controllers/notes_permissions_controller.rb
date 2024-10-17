class NotesPermissionsController < ApplicationController
  before_action :set_shared_note, only: [ :destroy, :update_permission ]

  def index
    @shared_notes = NotePermission.where(user_id: current_user.id).map do |permission_record|
      note = permission_record.note
      {
        id: note.id,
        title: note.title,
        content: note.description,  # Ensure to match the actual field in the Note model
        shared_by: permission_record.shared_by,
        permission: permission_record.permission
      }
    end

    render "note_permissions/index"
  end


  def destroy
    if @shared_note
      @shared_note.destroy
      render json: { message: "Note sharing removed successfully" }, status: :ok
    else
      render json: { error: "Sharing not found for this user" }, status: :not_found
    end
  end

  def update_permission
    if @shared_note
      if @shared_note.update(permission: params[:permission])
        render json: { message: "Permission updated successfully" }, status: :ok
      else
        render json: { error: "Failed to update permission" }, status: :unprocessable_entity
      end
    else
      render json: { error: "Note sharing not found" }, status: :not_found
    end
  end

  def shared_notes
    user = User.find(current_user.id)
    Rails.logger.info "Current user: #{user.username}"

    shared_notes = NotePermission.where(shared_by: user.username)

    render json: {
      shared_notes: shared_notes.map do |permission_record|
        note = permission_record.note
        {
          id: note.id,
          user_id: permission_record.user_id,
          title: note.title,
          content: note.description, # Ensure to match the actual field in the Note model
          shared_to: permission_record.shared_to,
          permission: permission_record.permission
        }
      end
    }, status: :ok
  end

  private

  def note_params
    params.require(:note).permit(:title, :description, :visibility, :view_later)
  end

  def set_shared_note
    user_to_remove = User.find_by(username: params[:username])
    if user_to_remove
      @shared_note = NotePermission.find_by(note_id: params[:id], user_id: user_to_remove.id)
    else
      @shared_note = nil
    end
  end
end

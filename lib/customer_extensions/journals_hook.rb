class ClientJournalsHook < Redmine::Hook::ViewListener

  def view_issues_edit_notes_bottom(context = {})
    controller = context[:controller]
    controller.send(:render_to_string, :partial => "toggle_visible")
  end

  def controller_issues_edit_before_save(context = {})
    journal = context[:journal]
    params = context[:params]
    journal.client_visible= params[:client_visible] or 0#unless journal.client_visible == params[:client_visible]
  end

end


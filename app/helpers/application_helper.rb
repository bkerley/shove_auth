# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def current_revision
    File.read(".git/refs/heads/master")
  end
end

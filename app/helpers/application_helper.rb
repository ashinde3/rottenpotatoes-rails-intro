module ApplicationHelper
  def hilite(field)
    "hilite" unless params[:sort] != field
  end
end

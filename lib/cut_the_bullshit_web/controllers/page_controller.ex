defmodule CutTheBullshitWeb.PageController do
  use CutTheBullshitWeb, :controller

  alias CutTheBullshitWeb.Router.Helpers, as: Routes

  def index(conn, _params) do
    redirect(conn, to: Routes.post_index_path(conn, :index))
    # redirect(conn, "/posts")
  end
end

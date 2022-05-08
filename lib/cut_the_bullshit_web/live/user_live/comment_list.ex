defmodule CutTheBullshitWeb.UserLive.CommentList do
  use CutTheBullshitWeb, :live_view

  alias CutTheBullshit.{Accounts, Comments}

  require Logger

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_defaults(session, socket)}
  end

  @impl true

  def handle_params(%{"id" => id} = params, _, socket) do
    page = if is_nil(params["page"]), do: 1, else: params["page"] |> String.to_integer()

    user = Accounts.get_user!(id)
    comments = Comments.list_comments_of_user(user, page)

    {:noreply,
     socket
     |> assign(:user, user)
     |> assign(:page, page)
     |> assign(:comments, comments)
     |> assign(:page_title, "#{user.username}'s comments")}
  end
end

defmodule CutTheBullshitWeb.PostLive.Show do
  use CutTheBullshitWeb, :live_view

  alias CutTheBullshit.Posts
  alias CutTheBullshit.Comments
  alias CutTheBullshit.Comments.Comment

  require Logger

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_defaults(session, socket)}
  end

  @impl true

  def handle_params(%{"id" => id} = params, _, socket) do
    post = Posts.get_post!(id)

    comment =
      case params do
        %{"comment_id" => comment_id} -> Comments.get_comment!(comment_id)
        _ -> %Comment{}
      end

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:post, post)
     |> assign(:comment, comment)}
  end

  defp page_title(:show), do: "Show Post"
  defp page_title(:edit_comment), do: "Show Post"
  defp page_title(:new_comment), do: "Show Post"
  defp page_title(:edit), do: "Edit Post"
end

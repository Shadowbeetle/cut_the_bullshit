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

    comment_count = Posts.get_comment_count(id)

    comment =
      case params do
        %{"comment_id" => comment_id} -> Comments.get_comment!(comment_id)
        _ -> %Comment{}
      end

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:post, post)
     |> assign(:comment, comment)
     |> assign(:comment_count, comment_count)}
  end

  @impl true
  def handle_event("delete_comment", %{"id" => id}, socket) do
    {:ok, _} =
      Comments.get_comment!(id)
      |> Comments.delete_comment()

    {:noreply,
     socket
     |> assign(:post, Posts.get_post!(socket.assigns.post.id))
     |> put_flash(:info, "Comment deleted successfully")}
  end

  defp page_title(:show), do: "Show Post"
  defp page_title(:edit_comment), do: "Show Post"
  defp page_title(:new_comment), do: "Show Post"
  defp page_title(:edit), do: "Edit Post"
end

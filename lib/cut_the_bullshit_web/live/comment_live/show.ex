defmodule CutTheBullshitWeb.CommentLive.Show do
  use CutTheBullshitWeb, :live_view

  import CutTheBullshitWeb.PostLive.ComponentHelpers
  alias CutTheBullshit.Posts
  alias CutTheBullshit.Comments

  require Logger

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_defaults(session, socket)}
  end

  @impl true

  def handle_params(%{"post_id" => post_id, "comment_id" => comment_id} = _params, _, socket) do
    # id = String.to_integer(id)

    post = get_post!(post_id, socket.assigns)
    comment = get_comment!(comment_id, socket.assigns)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:post, post)
     |> assign(:comment, comment)}
  end

  @impl true
  def handle_event("delete_comment", %{"id" => id}, socket) do
    {:ok, _} =
      Comments.get_comment!(id)
      |> Comments.delete_comment(socket.assigns.post)

    {:noreply,
     socket
     |> assign(
       :comment,
       get_comment!(socket.assigns.comment.id, socket.assigns)
     )
     |> put_flash(:info, "Comment deleted successfully")}
  end

  defp page_title(:show), do: "Show Post"
  defp page_title(:edit_comment), do: "Show Post"
  defp page_title(:new_comment), do: "Show Post"
  defp page_title(:edit), do: "Edit Post"

  defp get_post!(post_id, assigns) do
    if Map.has_key?(assigns, :current_user) and not is_nil(assigns.current_user) do
      Posts.get_post!(post_id, assigns.current_user)
    else
      Posts.get_post!(post_id)
    end
  end

  defp get_comment!(id, assigns) do
    if Map.has_key?(assigns, :current_user) and not is_nil(assigns.current_user) do
      Comments.get_comment!(id, assigns.current_user)
    else
      Comments.get_comment!(id)
    end
  end
end

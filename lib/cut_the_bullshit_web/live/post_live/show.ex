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
    page = if is_nil(params["page"]), do: 1, else: params["page"] |> String.to_integer()

    # TODO fix this, so that it returns a post with empty comments[] when the page goes over the last item
    post = get_post(id, socket.assigns, page)

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
     |> assign(:comment_count, comment_count)
     |> assign(:page, page)}
  end

  @impl true
  def handle_event("delete_comment", %{"id" => id}, socket) do
    {:ok, _} =
      Comments.get_comment!(id)
      |> Comments.delete_comment(socket.assigns.post)

    {:noreply,
     socket
     |> assign(:post, get_post(socket.assigns.post.id, socket.assigns, socket.assigns.page))
     |> put_flash(:info, "Comment deleted successfully")}
  end

  defp page_title(:show), do: "Show Post"
  defp page_title(:edit_comment), do: "Show Post"
  defp page_title(:new_comment), do: "Show Post"
  defp page_title(:edit), do: "Edit Post"

  defp get_post(post_id, assigns, page) do
    if Map.has_key?(assigns, :current_user) and not is_nil(assigns.current_user) do
      Posts.get_post(post_id, assigns.current_user, page)
    else
      Posts.get_post(post_id, page)
    end
  end
end

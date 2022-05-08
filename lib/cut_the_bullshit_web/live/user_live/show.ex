defmodule CutTheBullshitWeb.UserLive.Show do
  use CutTheBullshitWeb, :live_view

  alias CutTheBullshit.Accounts

  require Logger

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_defaults(session, socket |> Surface.init())}
  end

  @impl true

  def handle_params(%{"id" => id} = _params, _, socket) do
    # id = String.to_integer(id)

    user = Accounts.get_user!(id)

    {:noreply,
     socket
     |> assign(:user, user)
     |> assign(:page_title, "#{user.username}'s Profile")}
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

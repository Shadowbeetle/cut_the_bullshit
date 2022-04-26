defmodule CutTheBullshitWeb.CommentLive.Show do
  use CutTheBullshitWeb, :live_view

  alias CutTheBullshit.Comments

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_defaults(session,socket)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:comment, Comments.get_comment!(id))}
  end

  defp page_title(:show), do: "Show Comment"
  defp page_title(:edit), do: "Edit Comment"
end

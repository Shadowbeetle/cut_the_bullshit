defmodule CutTheBullshitWeb.PostLive.VoteComponent do
  use CutTheBullshitWeb, :live_component

  alias CutTheBullshit.Posts

  require Logger

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)}
  end

  @impl true
  def handle_event("upvote", _params, socket) do
    case Posts.vote_on_post(socket.assigns.post, socket.assigns.current_user, :up) do
      {:ok, %{post: post, vote: _}} ->
        {:noreply,
         socket
         |> assign(post: post)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

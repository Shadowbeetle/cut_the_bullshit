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
  def handle_event("vote", %{"vote-type" => vote_type} = _params, socket) do
    case Posts.vote_on_post(
           socket.assigns.post,
           socket.assigns.current_user,
           vote_type |> String.to_atom()
         ) do
      {:ok, %{post: post, vote: vote}} ->
        {:noreply,
         socket
         |> assign(post: post |> Map.put(:vote_of_current_user, vote.value))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp get_up_arrow_style(vote_of_current_user) do
    case vote_of_current_user do
      :up -> "color: red"
      :down -> ""
      _ -> ""
    end
  end

  defp get_down_arrow_style(vote_of_current_user) do
    case vote_of_current_user do
      :down -> "color: red"
      :up -> ""
      _ -> ""
    end
  end
end

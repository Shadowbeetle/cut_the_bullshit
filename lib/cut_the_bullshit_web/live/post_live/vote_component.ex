defmodule CutTheBullshitWeb.PostLive.VoteComponent do
  use CutTheBullshitWeb, :live_component

  alias CutTheBullshit.Posts
  alias CutTheBullshit.Posts.Post
  alias CutTheBullshit.Accounts.User

  require Logger

  @impl true
  def update(assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)}
  end

  @impl true
  def handle_event("vote", %{"vote-type" => vote_type} = _params, socket) do
    %{post: post, current_user: current_user} = socket.assigns
    %{vote_of_current_user: vote_of_current_user} = post
    vote_type = String.to_atom(vote_type)

    result =
      case vote_of_current_user do
        nil -> save_vote(:new, vote_type, post, current_user)
        :up -> save_vote(:change, vote_type, post, current_user)
        :down -> save_vote(:change, vote_type, post, current_user)
      end

    case result do
      {:ok, post} ->
        {:noreply,
         socket
         |> assign(post: post)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def save_vote(:new, vote_type, %Post{} = post, %User{} = current_user) do
    Posts.vote_on_post(post, current_user, vote_type)
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

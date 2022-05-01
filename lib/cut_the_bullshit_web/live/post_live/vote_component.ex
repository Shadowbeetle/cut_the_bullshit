defmodule CutTheBullshitWeb.PostLive.VoteComponent do
  use CutTheBullshitWeb, :live_component

  alias CutTheBullshit.Posts
  alias CutTheBullshit.Posts.Post
  alias CutTheBullshit.Posts.Vote
  alias CutTheBullshit.Accounts.User

  require Logger

  @impl true
  def update(assigns, socket) do
    vote_of_current_user =
      if is_nil(assigns.post.vote_of_current_user) do
        %Vote{}
      else
        assigns.post.vote_of_current_user
      end

    assigns = put_in(assigns.post.vote_of_current_user, vote_of_current_user)

    {:ok,
     socket
     |> assign(assigns)}
  end

  @impl true
  def handle_event("vote", %{"vote-type" => clicked_vote} = _params, socket) do
    %{post: post, current_user: current_user} = socket.assigns
    %{vote_of_current_user: vote_of_current_user} = post
    clicked_vote = String.to_atom(clicked_vote)

    result =
      case vote_of_current_user.value do
        nil -> save_vote(:new, post, current_user, clicked_vote)
        _ -> save_vote(:change, post, clicked_vote)
      end

    case result do
      {:ok, post} ->
        {:noreply,
         socket
         |> assign(post: post)}
    end
  end

  def save_vote(:new, %Post{} = post, %User{} = current_user, clicked_vote) do
    Posts.vote_on_post(post, current_user, clicked_vote)
  end

  def save_vote(:change, %Post{} = post, clicked_vote) do
    current_vote_value = post.vote_of_current_user.value

    if clicked_vote == current_vote_value do
      Posts.remove_vote_from_post(post, post.vote_of_current_user)
    else
      Posts.change_vote_on_post(post, post.vote_of_current_user, clicked_vote)
    end
  end

  defp get_up_arrow_style(%Post{} = post) do
    vote_of_current_user = get_vote_value_of_current_user(post)

    case vote_of_current_user do
      :up -> "color: red"
      :down -> ""
      _ -> ""
    end
  end

  defp get_down_arrow_style(%Post{} = post) do
    vote_of_current_user = get_vote_value_of_current_user(post)

    case vote_of_current_user do
      :down -> "color: red"
      :up -> ""
      _ -> ""
    end
  end

  defp get_vote_value_of_current_user(%Post{} = post) do
    get_in(post, [Access.key(:vote_of_current_user), Access.key(:value)])
  end
end

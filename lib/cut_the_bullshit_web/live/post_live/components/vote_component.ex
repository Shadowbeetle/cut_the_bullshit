defmodule CutTheBullshitWeb.PostLive.VoteComponent do
  use CutTheBullshitWeb, :live_component

  alias CutTheBullshit.Posts
  alias CutTheBullshit.Posts.Post
  alias CutTheBullshit.Posts.Vote
  alias CutTheBullshit.Comments
  alias CutTheBullshit.Comments.Comment
  alias CutTheBullshit.Comments.Vote
  alias CutTheBullshit.Accounts.User

  require Logger

  @impl true
  def update(assigns, socket) do
    vote_of_current_user =
      if is_nil(assigns.content.vote_of_current_user) do
        %Vote{}
      else
        assigns.content.vote_of_current_user
      end

    assigns = put_in(assigns.content.vote_of_current_user, vote_of_current_user)

    {:ok,
     socket
     |> assign(assigns)}
  end

  @impl true
  def handle_event("vote", %{"vote-type" => clicked_vote} = _params, socket) do
    %{content: content, current_user: current_user} = socket.assigns
    %{vote_of_current_user: vote_of_current_user} = content
    clicked_vote = String.to_atom(clicked_vote)

    result =
      case vote_of_current_user.value do
        nil -> save_vote(:new, content, current_user, clicked_vote)
        _ -> save_vote(:change, content, clicked_vote)
      end

    case result do
      {:ok, content} ->
        {:noreply,
         socket
         |> assign(content: content)}
    end
  end


  def save_vote(:new, %Post{} = post, %User{} = current_user, clicked_vote) do
    Posts.vote_on_post(post, current_user, clicked_vote)
  end

  def save_vote(:new, %Comment{} = comment, %User{} = current_user, clicked_vote) do
    Comments.vote_on_comment(comment, current_user, clicked_vote)
  end

  def save_vote(:change, %Post{} = post, clicked_vote) do
    current_vote_value = post.vote_of_current_user.value

    if clicked_vote == current_vote_value do
      Posts.remove_vote_from_post(post, post.vote_of_current_user)
    else
      Posts.change_vote_on_post(post, post.vote_of_current_user, clicked_vote)
    end
  end

  def save_vote(:change, %Comment{} = comment, clicked_vote) do
    current_vote_value = comment.vote_of_current_user.value

    if clicked_vote == current_vote_value do
      Comments.remove_vote_from_comment(comment, comment.vote_of_current_user)
    else
      Comments.change_vote_on_comment(comment, comment.vote_of_current_user, clicked_vote)
    end
  end

  defp get_up_arrow_style(content) do
    vote_of_current_user = get_vote_value_of_current_user(content)

    case vote_of_current_user do
      :up -> "color: red"
      :down -> ""
      _ -> ""
    end
  end

  defp get_down_arrow_style(content) do
    vote_of_current_user = get_vote_value_of_current_user(content)

    case vote_of_current_user do
      :down -> "color: red"
      :up -> ""
      _ -> ""
    end
  end

  defp get_vote_value_of_current_user(content) do
    get_in(content, [Access.key(:vote_of_current_user), Access.key(:value)])
  end
end

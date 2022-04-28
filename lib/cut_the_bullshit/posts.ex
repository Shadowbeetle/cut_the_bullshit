defmodule CutTheBullshit.Posts do
  @moduledoc """
  The Posts context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi

  alias CutTheBullshit.Repo

  alias CutTheBullshit.Posts.Post
  alias CutTheBullshit.Posts.Vote
  alias CutTheBullshit.Accounts.User

  require Logger

  @doc """
  Returns the list of posts.

  ## Examples

      iex> list_posts()
      [%Post{}, ...]

  """
  def list_posts do
    query =
      from p in Post,
        left_join: user in assoc(p, :user),
        left_join: comment in assoc(p, :comments),
        group_by: [p.id, user.id],
        select_merge: %{comment_count: count(comment.id)},
        preload: [user: user]

    Repo.all(query)
  end

  def list_posts_with_users_upvotes(current_user_id) do
    query =
      from p in Post,
        left_join: user in assoc(p, :user),
        left_join: comment in assoc(p, :comments),
        left_join: v in Vote,
        on: [user_id: ^current_user_id, post_id: p.id],
        select: %{post: p, vote_of_current_user: v.value},
        group_by: [p.id, user.id, v.value],
        select_merge: %{comment_count: count(comment.id)},
        preload: [user: user]

    Repo.all(query)
  end

  @doc """
  Gets a single post.

  Raises `Ecto.NoResultsError` if the Post does not exist.

  ## Examples

      iex> get_post!(123)
      %Post{}

      iex> get_post!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post!(id) do
    query =
      from p in Post,
        where: p.id == ^id,
        left_join: user in assoc(p, :user),
        left_join: comments in assoc(p, :comments),
        left_join: comment_user in assoc(comments, :user),
        preload: [comments: {comments, user: comment_user}, user: user]

    Repo.one!(query)
  end

  def get_comment_count(id) do
    query =
      from p in Post,
        where: p.id == ^id,
        left_join: comment in assoc(p, :comments)

    Repo.aggregate(query, :count, :id)
  end

  @doc """
  Creates a post.

  ## Examples

      iex> create_post(%{field: value})
      {:ok, post: %Post{}, vote: %Vote{}}

      iex> create_post(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post(attrs \\ %{}) do
    Multi.new()
    |> Multi.insert(:post, Post.changeset(%Post{}, attrs))
    |> create_vote(attrs["user_id"], :up)
    |> Repo.transaction()
  end

  @doc """
  Updates a post.

  ## Examples

      iex> update_post(post, %{field: new_value})
      {:ok, %Post{}}

      iex> update_post(post, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a post.

  ## Examples

      iex> delete_post(post)
      {:ok, %Post{}}

      iex> delete_post(post)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post changes.

  ## Examples

      iex> change_post(post)
      %Ecto.Changeset{data: %Post{}}

  """
  def change_post(%Post{} = post, attrs \\ %{}) do
    Post.changeset(post, attrs)
  end

  @doc """
  Returns the list of votes.

  ## Examples

      iex> list_votes()
      [%Vote{}, ...]

  """
  def list_votes do
    Repo.all(Vote)
  end

  @doc """
  Gets a single vote.

  Raises `Ecto.NoResultsError` if the Post vote does not exist.

  ## Examples

      iex> get_vote!(123)
      %Vote{}

      iex> get_vote!(456)
      ** (Ecto.NoResultsError)

  """
  def get_vote!(id), do: Repo.get!(Vote, id)

  defp create_vote(transaction, user_id, vote_type) when vote_type in [:up, :down] do
    Multi.insert(
      transaction,
      :vote,
      fn post_insert_result ->
        Logger.info("post_insert_result: #{inspect(post_insert_result)}")

        case post_insert_result do
          %{post: post} ->
            Vote.changeset(%Vote{}, %{value: vote_type, post_id: post.id, user_id: user_id})

          {:error, changeset} ->
            {:error, changeset}

          _ ->
            raise "Unexpected result: #{inspect(post_insert_result)}"
        end
      end
    )
  end

  @doc """
  Updates a vote.

  ## Examples

      iex> update_vote(vote, %{field: new_value})
      {:ok, %Vote{}}

      iex> update_vote(vote, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_vote(%Vote{} = vote, attrs) do
    vote
    |> Vote.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a vote.

  ## Examples

      iex> delete_vote(vote)
      {:ok, %Vote{}}

      iex> delete_vote(vote)
      {:error, %Ecto.Changeset{}}

  """
  def delete_vote(%Vote{} = vote) do
    Repo.delete(vote)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking vote changes.

  ## Examples

      iex> change_vote(vote)
      %Ecto.Changeset{data: %Vote{}}

  """
  def change_vote(%Vote{} = vote, attrs \\ %{}) do
    Vote.changeset(vote, attrs)
  end

  def vote_on_post(%Post{} = post, %User{} = current_user, vote_type)
      when vote_type in [:up, :down] do
    Logger.info("vote_on_post: #{inspect(post)}")

    attrs =
      case vote_type do
        :up -> %{votes: post.votes + 1, id: post.id, user_id: post.user.id}
        :down -> %{votes: post.votes - 1, id: post.id, user_id: post.user.id}
      end

    Logger.info("changeset: #{Post.vote_changeset(%Post{}, attrs) |> Map.get(:data) |> inspect}")

    Multi.new()
    |> Multi.update(:post, Post.vote_changeset(post, attrs))
    |> create_vote(current_user.id, vote_type)
    |> Repo.transaction()
  end

  def remove_vote_from_post(%Post{} = post) do
    %Vote{}
    |> Vote.changeset(%{value: :none, post_id: post.id, user_id: post.user_id})
    |> Repo.insert()
  end
end

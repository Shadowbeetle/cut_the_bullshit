defmodule CutTheBullshit.Comments do
  @moduledoc """
  The Comments context.
  """

  import Ecto.Query, warn: false
  alias Ecto.Multi

  alias CutTheBullshit.Repo

  alias CutTheBullshit.Comments.Comment
  alias CutTheBullshit.Comments.Vote
  alias CutTheBullshit.Posts.Post
  alias CutTheBullshit.Accounts.User

  require Logger

  @doc """
  Returns the list of comments.

  ## Examples

      iex> list_comments()
      [%Comment{}, ...]

  """
  def list_comments do
    Repo.all(Comment) |> Repo.preload(:user)
  end

  def list_comments_of_post(%Post{} = post) do
    query =
      from c in Comment,
        where: c.post_id == ^post.id,
        order_by: [desc: :inserted_at]

    Repo.all(query) |> Repo.preload(:user)
  end

  def list_comments_of_post(%Post{} = post, %User{} = current_user) do
    query =
      from c in Comment,
        where: c.post_id == ^post.id,
        left_join: user in assoc(c, :user),
        left_join: vote in Vote,
        on: [user_id: ^current_user.id, comment_id: c.id],
        group_by: [c.id, vote.id],
        preload: [user: user, vote_of_current_user: vote],
        order_by: [asc: :inserted_at]

    Repo.all(query)
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!(123)
      %Comment{}

      iex> get_comment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment!(id), do: Repo.get!(Comment, id) |> Repo.preload(:user)

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(attrs \\ %{}) do
    Multi.new()
    |> Multi.insert(:comment, Comment.changeset(%Comment{}, attrs))
    |> Multi.insert(:vote, fn comment_insert_result ->
      case comment_insert_result do
        %{comment: comment} ->
          Vote.changeset(%Vote{}, %{value: :up, comment_id: comment.id, user_id: comment.user_id})

        {:error, changeset} ->
          {:error, changeset}

        _ ->
          raise "Unexpected result: #{inspect(comment_insert_result)}"
      end
    end)
    |> Repo.transaction()
  end

  defp add_vote_to_comment_transaction(transaction_result) do
    case transaction_result do
      {:ok, %{comment: comment, vote: vote}} ->
        {:ok, Map.put(comment, :vote_of_current_user, vote)}

      other ->
        other
    end
  end

  defp add_empty_vote_to_comment_transaction(transaction_result) do
    case transaction_result do
      {:ok, %{comment: comment, vote: _}} ->
        {:ok, Map.put(comment, :vote_of_current_user, %Vote{})}

      other ->
        other
    end
  end

  @doc """
  Updates a comment.

  ## Examples

      iex> update_comment(comment, %{field: new_value})
      {:ok, %Comment{}}

      iex> update_comment(comment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment changes.

  ## Examples

      iex> change_comment(comment)
      %Ecto.Changeset{data: %Comment{}}

  """
  def change_comment(%Comment{} = comment, attrs \\ %{}) do
    Comment.changeset(comment, attrs)
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

  Raises `Ecto.NoResultsError` if the Comment vote does not exist.

  ## Examples

      iex> get_vote!(123)
      %Vote{}

      iex> get_vote!(456)
      ** (Ecto.NoResultsError)

  """
  def get_vote!(id), do: Repo.get!(Vote, id)

  defp create_vote(transaction, name, user_id, vote_type) when vote_type in [:up, :down] do
    Multi.insert(
      transaction,
      name,
      fn comment_insert_result ->
        case comment_insert_result do
          %{comment: comment} ->
            Vote.changeset(%Vote{}, %{value: vote_type, comment_id: comment.id, user_id: user_id})

          {:error, changeset} ->
            {:error, changeset}

          _ ->
            raise "Unexpected result: #{inspect(comment_insert_result)}"
        end
      end
    )
  end

  @doc """
  Creates a vote.

  ## Examples

      iex> create_vote(%{field: value})
      {:ok, %Vote{}}

      iex> create_vote(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_vote(attrs \\ %{}) do
    %Vote{}
    |> Vote.changeset(attrs)
    |> Repo.insert()
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

  def vote_on_comment(%Comment{} = comment, %User{} = current_user, vote_type)
      when vote_type in [:up, :down] do
    attrs =
      case vote_type do
        :up -> %{votes: comment.votes + 1, id: comment.id, user_id: comment.user.id}
        :down -> %{votes: comment.votes - 1, id: comment.id, user_id: comment.user.id}
      end

    Multi.new()
    |> Multi.update(:comment, Comment.vote_changeset(comment, attrs))
    |> create_vote(:vote, current_user.id, vote_type)
    |> Repo.transaction()
    |> add_vote_to_comment_transaction()
  end

  def remove_vote_from_comment(%Comment{} = comment, %Vote{} = vote) do
    attrs =
      case vote.value do
        :up -> %{votes: comment.votes - 1, id: comment.id, user_id: comment.user.id}
        :down -> %{votes: comment.votes + 1, id: comment.id, user_id: comment.user.id}
      end

    Multi.new()
    |> Multi.update(:comment, Comment.vote_changeset(comment, attrs))
    |> Multi.delete(:vote, vote)
    |> Repo.transaction()
    |> add_empty_vote_to_comment_transaction()
  end

  def change_vote_on_comment(%Comment{} = comment, %Vote{} = vote, new_vote_type) do
    attrs =
      case new_vote_type do
        :up -> %{votes: comment.votes + 2, id: comment.id, user_id: comment.user.id}
        :down -> %{votes: comment.votes - 2, id: comment.id, user_id: comment.user.id}
      end

    Multi.new()
    |> Multi.update(:comment, Comment.vote_changeset(comment, attrs))
    |> Multi.update(:vote, Vote.changeset(vote, %{value: new_vote_type}))
    |> Repo.transaction()
    |> add_vote_to_comment_transaction()
  end
end

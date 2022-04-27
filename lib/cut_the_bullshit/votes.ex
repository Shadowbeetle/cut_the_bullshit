defmodule CutTheBullshit.Votes do
  @moduledoc """
  The Votes context.
  """

  import Ecto.Query, warn: false
  alias CutTheBullshit.Repo

  alias CutTheBullshit.Votes.PostVote

  require Logger

  @doc """
  Returns the list of post_votes.

  ## Examples

      iex> list_post_votes()
      [%PostVote{}, ...]

  """
  def list_post_votes do
    Repo.all(PostVote)
  end

  @doc """
  Gets a single post_vote.

  Raises `Ecto.NoResultsError` if the Post vote does not exist.

  ## Examples

      iex> get_post_vote!(123)
      %PostVote{}

      iex> get_post_vote!(456)
      ** (Ecto.NoResultsError)

  """
  def get_post_vote!(id), do: Repo.get!(PostVote, id)

  @doc """
  Creates a post_vote.

  ## Examples

      iex> create_post_vote(%{field: value})
      {:ok, %PostVote{}}

      iex> create_post_vote(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_post_vote(attrs \\ %{}) do
    Logger.info("Creating post_vote: #{inspect(attrs)}")

    %PostVote{}
    |> PostVote.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a post_vote.

  ## Examples

      iex> update_post_vote(post_vote, %{field: new_value})
      {:ok, %PostVote{}}

      iex> update_post_vote(post_vote, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_post_vote(%PostVote{} = post_vote, attrs) do
    post_vote
    |> PostVote.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a post_vote.

  ## Examples

      iex> delete_post_vote(post_vote)
      {:ok, %PostVote{}}

      iex> delete_post_vote(post_vote)
      {:error, %Ecto.Changeset{}}

  """
  def delete_post_vote(%PostVote{} = post_vote) do
    Repo.delete(post_vote)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking post_vote changes.

  ## Examples

      iex> change_post_vote(post_vote)
      %Ecto.Changeset{data: %PostVote{}}

  """
  def change_post_vote(%PostVote{} = post_vote, attrs \\ %{}) do
    PostVote.changeset(post_vote, attrs)
  end

  alias CutTheBullshit.Votes.CommentVote

  @doc """
  Returns the list of comment_votes.

  ## Examples

      iex> list_comment_votes()
      [%CommentVote{}, ...]

  """
  def list_comment_votes do
    Repo.all(CommentVote)
  end

  @doc """
  Gets a single comment_vote.

  Raises `Ecto.NoResultsError` if the Comment vote does not exist.

  ## Examples

      iex> get_comment_vote!(123)
      %CommentVote{}

      iex> get_comment_vote!(456)
      ** (Ecto.NoResultsError)

  """
  def get_comment_vote!(id), do: Repo.get!(CommentVote, id)

  @doc """
  Creates a comment_vote.

  ## Examples

      iex> create_comment_vote(%{field: value})
      {:ok, %CommentVote{}}

      iex> create_comment_vote(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment_vote(attrs \\ %{}) do
    %CommentVote{}
    |> CommentVote.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a comment_vote.

  ## Examples

      iex> update_comment_vote(comment_vote, %{field: new_value})
      {:ok, %CommentVote{}}

      iex> update_comment_vote(comment_vote, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_comment_vote(%CommentVote{} = comment_vote, attrs) do
    comment_vote
    |> CommentVote.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a comment_vote.

  ## Examples

      iex> delete_comment_vote(comment_vote)
      {:ok, %CommentVote{}}

      iex> delete_comment_vote(comment_vote)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment_vote(%CommentVote{} = comment_vote) do
    Repo.delete(comment_vote)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking comment_vote changes.

  ## Examples

      iex> change_comment_vote(comment_vote)
      %Ecto.Changeset{data: %CommentVote{}}

  """
  def change_comment_vote(%CommentVote{} = comment_vote, attrs \\ %{}) do
    CommentVote.changeset(comment_vote, attrs)
  end
end

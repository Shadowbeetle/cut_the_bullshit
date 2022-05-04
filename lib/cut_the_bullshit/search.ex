defmodule CutTheBullshit.Search do
  @moduledoc """
  The Search context.
  """

  import Ecto.Query, warn: false
  alias CutTheBullshit.Repo

  alias CutTheBullshit.Search.Query

  @doc """
  Returns the list of query.

  ## Examples

      iex> list_query()
      [%Query{}, ...]

  """
  def list_query do
    Repo.all(Query)
  end

  @doc """
  Gets a single query.

  Raises `Ecto.NoResultsError` if the Query does not exist.

  ## Examples

      iex> get_query!(123)
      %Query{}

      iex> get_query!(456)
      ** (Ecto.NoResultsError)

  """
  def get_query!(id), do: Repo.get!(Query, id)

  @doc """
  Creates a query.

  ## Examples

      iex> create_query(%{field: value})
      {:ok, %Query{}}

      iex> create_query(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_query(attrs \\ %{}) do
    %Query{}
    |> Query.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a query.

  ## Examples

      iex> update_query(query, %{field: new_value})
      {:ok, %Query{}}

      iex> update_query(query, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_query(%Query{} = query, attrs) do
    query
    |> Query.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a query.

  ## Examples

      iex> delete_query(query)
      {:ok, %Query{}}

      iex> delete_query(query)
      {:error, %Ecto.Changeset{}}

  """
  def delete_query(%Query{} = query) do
    Repo.delete(query)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking query changes.

  ## Examples

      iex> change_query(query)
      %Ecto.Changeset{data: %Query{}}

  """
  def change_query(%Query{} = query, attrs \\ %{}) do
    Query.changeset(query, attrs)
  end
end

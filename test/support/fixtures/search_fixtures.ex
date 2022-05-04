defmodule CutTheBullshit.SearchFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CutTheBullshit.Search` context.
  """

  @doc """
  Generate a query.
  """
  def query_fixture(attrs \\ %{}) do
    {:ok, query} =
      attrs
      |> Enum.into(%{
        term: "some term"
      })
      |> CutTheBullshit.Search.create_query()

    query
  end
end

defmodule CutTheBullshit.Search.Query do
  use Ecto.Schema
  import Ecto.Changeset

  schema "query" do
    field :term, :string, virtual: true
  end

  @doc false
  def changeset(query, attrs) do
    query
    |> cast(attrs, [:term])
  end
end

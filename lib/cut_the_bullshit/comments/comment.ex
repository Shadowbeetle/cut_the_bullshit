defmodule CutTheBullshit.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  require Logger

  schema "comments" do
    field :text, :string
    field :user_id, :id
    field :post_id, :id

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:text, :user_id, :post_id])
    |> validate_required([:text, :user_id, :post_id])
  end
end

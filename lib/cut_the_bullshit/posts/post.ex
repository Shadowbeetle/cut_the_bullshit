defmodule CutTheBullshit.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :description, :string
    field :title, :string
    field :url, :string
    field :user_id, :id

    belongs_to :user, CutTheBullshit.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :description, :url, :user_id])
    |> validate_required([:title, :description, :url, :user_id])
  end
end

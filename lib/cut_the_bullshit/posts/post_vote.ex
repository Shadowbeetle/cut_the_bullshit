defmodule CutTheBullshit.Posts.Vote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "post_votes" do
    field :value, Ecto.Enum, values: [:up, :down]

    belongs_to :user, CutTheBullshit.Accounts.User
    belongs_to :post, CutTheBullshit.Posts.Post

    timestamps()
  end

  @doc false
  def changeset(post_vote, attrs) do
    post_vote
    |> cast(attrs, [:value, :user_id, :post_id])
    |> validate_required([:value])
  end
end

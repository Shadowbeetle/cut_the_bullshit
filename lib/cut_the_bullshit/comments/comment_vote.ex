defmodule CutTheBullshit.Comments.Vote do
  use Ecto.Schema
  import Ecto.Changeset

  schema "comment_votes" do
    field :value, Ecto.Enum, values: [:up, :down]

    belongs_to :user, CutTheBullshit.Accounts.User
    belongs_to :comment, CutTheBullshit.Comments.Comment

    timestamps()
  end

  @doc false
  def changeset(comment_vote, attrs) do
    comment_vote
    |> cast(attrs, [:value, :user_id, :comment_id])
    |> validate_required([:value])
  end
end

defmodule CutTheBullshit.Comments.Comment do
  use Ecto.Schema
  import Ecto.Changeset

  require Logger

  schema "comments" do
    field :text, :string
    field :votes, :integer

    belongs_to :user, CutTheBullshit.Accounts.User
    belongs_to :post, CutTheBullshit.Posts.Post
    has_many :comment_votes, CutTheBullshit.Comments.Vote
    has_one :vote_of_current_user, CutTheBullshit.Comments.Vote

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:text, :votes, :user_id, :post_id])
    |> validate_required([:text, :user_id, :post_id])
  end
end

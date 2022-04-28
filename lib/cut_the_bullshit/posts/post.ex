defmodule CutTheBullshit.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :description, :string
    field :title, :string
    field :url, :string
    field :votes, :integer
    field :comment_count, :integer, virtual: true
    field :vote_of_current_user, Ecto.Enum, values: [:up, :down], virtual: true

    belongs_to :user, CutTheBullshit.Accounts.User
    has_many :comments, CutTheBullshit.Comments.Comment
    has_many :post_votes, CutTheBullshit.Posts.Vote

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :votes, :description, :url, :user_id])
    |> validate_required([:title, :description, :url, :user_id])
  end

  @doc false
  def vote_changeset(post, attrs) do
    post
    |> cast(attrs, [:votes])
    |> validate_required([:votes])
  end
end

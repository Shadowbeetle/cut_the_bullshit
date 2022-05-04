defmodule CutTheBullshit.Posts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :description, :string
    field :title, :string
    field :url, :string
    field :votes, :integer
    field :comment_count, :integer

    belongs_to :user, CutTheBullshit.Accounts.User
    has_many :comments, CutTheBullshit.Comments.Comment
    has_many :post_votes, CutTheBullshit.Posts.Vote
    has_one :vote_of_current_user, CutTheBullshit.Posts.Vote

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :votes, :description, :url, :user_id, :comment_count])
    |> validate_required([:title, :description, :url, :user_id])
    |> validate_title("A post with this title already exists. Use the search bar to find it.")
  end

  @doc false
  def vote_changeset(post, attrs) do
    post
    |> cast(attrs, [:votes])
    |> validate_required([:votes])
  end

  defp validate_title(changeset, message) do
    changeset
    |> validate_required([:title])
    |> validate_length(:title, max: 160)
    |> unsafe_validate_unique(:title, CutTheBullshit.Repo, message: message)
    |> unique_constraint(:title, message: message)
  end
end

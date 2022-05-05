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
    |> validate_required([:title, :user_id])
    |> validate_url()
    |> validate_title("A post with this title already exists. Use the search bar to find it.")
    |> validate_description_or_url_required("Please provide either a URL or a description.")
  end

  @doc false
  def vote_changeset(post, attrs) do
    post
    |> cast(attrs, [:votes])
    |> validate_required([:votes])
  end

  defp validate_title(changeset, message) do
    changeset
    |> validate_length(:title, max: 255)
    |> unsafe_validate_unique(:title, CutTheBullshit.Repo, message: message)
    |> unique_constraint(:title, message: message)
  end

  defp validate_url(changeset) do
    changeset
    # Taken from here https://mathiasbynens.be/demo/url-regex
    |> validate_length(:url, max: 255)
    |> validate_format(:url, ~r"^(https?|ftp)://[^\s/$.?#].[^\s]*$"i,
      message: "Please enter a valid URL."
    )
  end

  defp validate_description_or_url_required(changeset, message) do
    changeset
    |> check_constraint(:description,
      name: :url_or_description_required,
      message: message
    )
    |> check_constraint(:description,
      name: :url_or_description_required,
      message: message
    )
  end
end

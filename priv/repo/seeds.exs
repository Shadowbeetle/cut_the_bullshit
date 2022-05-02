# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     CutTheBullshit.Repo.insert!(%CutTheBullshit.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

defmodule CutTheBullshit.Seed do
  alias CutTheBullshit.Accounts
  alias CutTheBullshit.Accounts.User
  alias CutTheBullshit.Posts
  alias CutTheBullshit.Posts.Post
  alias CutTheBullshit.Posts.Vote, as: PostVote
  alias CutTheBullshit.Comments
  alias CutTheBullshit.Comments.Comment
  alias CutTheBullshit.Comments.Vote, as: CommentVote

  def get_random_user_id(created_users) do
    Enum.random(0..(tuple_size(created_users) - 1))
  end

  def get_random_user(created_users) do
    elem(created_users, get_random_user_id(created_users))
  end

  def run() do
    created_users = create_users()
    create_content(created_users)
  end

  def create_users do
    for _ <- 1..20 do
      username = Faker.Superhero.name()

      email = username |> String.downcase() |> String.replace(" ", ".") |> Kernel.<>("@gmail.com")

      password = "almaalmaalma"

      Accounts.register_user(%{
        username: username,
        email: email,
        password: password
      })
    end
    |> Enum.filter(fn insert_result ->
      case insert_result do
        {:ok, _} -> true
        {:error, _} -> false
      end
    end)
    |> List.foldl([], fn {:ok, user}, acc -> [user | acc] end)
    |> List.to_tuple()
  end

  def create_content(created_users) do
    for _ <- 1..300 do
      post_insert_result = create_post(created_users)

      create_post_votes(post_insert_result, created_users)
      create_comments(post_insert_result, created_users)
    end
  end

  def create_post(created_users) do
    user = get_random_user(created_users)
    url = Faker.Internet.url()

    Posts.create_post(%{
      "user_id" => user.id,
      "url" => url,
      "title" =>
        url
        |> String.replace(~r"https?://", "")
        |> String.replace(~r"\..+$", "")
        |> String.capitalize(),
      "description" => Faker.Lorem.paragraph()
    })
  end

  def create_post_votes({:ok, %Post{} = post} = _post_insert_result, created_users) do
    for i <- 0..get_random_user_id(created_users) do
      voting_user = get_random_user(created_users)
      vote = if rem(i, 2) == 0, do: :up, else: :down

      if voting_user.id != post.user_id do
        Posts.vote_on_post(post, voting_user, vote)
      end
    end
  end

  def create_post_votes({:error, _} = _post_insert_result, _) do
    nil
  end

  def create_comments({:ok, %Post{} = post} = _post_insert_result, created_users) do
    for i <- 1..Enum.random(1..100) do
      user = get_random_user(created_users)

      text =
        cond do
          rem(i, 5) == 0 -> Faker.Lorem.Shakespeare.romeo_and_juliet()
          rem(i, 3) == 0 -> Faker.Lorem.Shakespeare.king_richard_iii()
          rem(i, 2) == 0 -> Faker.Lorem.Shakespeare.as_you_like_it()
          true -> Faker.Lorem.Shakespeare.hamlet()
        end

      comment_insert_result =
        Comments.create_comment(%{
          user_id: user.id,
          post_id: post.id,
          text: text
        })

      create_comment_votes(comment_insert_result, created_users)
    end
  end

  def create_comments({:ok, %Post{} = post} = _post_insert_result, created_users) do
    nil
  end

  def create_comment_votes({:ok, %Comment{} = comment} = _comment_insert_result, created_users) do
    for i <- 0..get_random_user_id(created_users) do
      voting_user = get_random_user(created_users)
      vote = if rem(i, 2) == 0, do: :up, else: :down

      if voting_user.id != comment.user_id do
        Comments.vote_on_comment(comment, voting_user, vote)
      end
    end
  end

  def create_comment_votes({:error, _} = _comment_insert_result, created_users) do
    nil
  end
end

CutTheBullshit.Seed.run()

defmodule CutTheBullshit.VotesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CutTheBullshit.Votes` context.
  """

  @doc """
  Generate a post_vote.
  """
  def post_vote_fixture(attrs \\ %{}) do
    {:ok, post_vote} =
      attrs
      |> Enum.into(%{
        value: :up
      })
      |> CutTheBullshit.Votes.create_post_vote()

    post_vote
  end

  @doc """
  Generate a comment_vote.
  """
  def comment_vote_fixture(attrs \\ %{}) do
    {:ok, comment_vote} =
      attrs
      |> Enum.into(%{
        value: :up
      })
      |> CutTheBullshit.Votes.create_comment_vote()

    comment_vote
  end
end

defmodule CutTheBullshit.CommentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CutTheBullshit.Comments` context.
  """

  @doc """
  Generate a comment.
  """
  def comment_fixture(attrs \\ %{}) do
    {:ok, comment} =
      attrs
      |> Enum.into(%{
        text: "some text"
      })
      |> CutTheBullshit.Comments.create_comment()

    comment
  end
end

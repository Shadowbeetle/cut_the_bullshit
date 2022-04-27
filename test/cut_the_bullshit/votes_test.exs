defmodule CutTheBullshit.VotesTest do
  use CutTheBullshit.DataCase

  alias CutTheBullshit.Votes

  describe "post_votes" do
    alias CutTheBullshit.Votes.PostVote

    import CutTheBullshit.VotesFixtures

    @invalid_attrs %{value: nil}

    test "list_post_votes/0 returns all post_votes" do
      post_vote = post_vote_fixture()
      assert Votes.list_post_votes() == [post_vote]
    end

    test "get_post_vote!/1 returns the post_vote with given id" do
      post_vote = post_vote_fixture()
      assert Votes.get_post_vote!(post_vote.id) == post_vote
    end

    test "create_post_vote/1 with valid data creates a post_vote" do
      valid_attrs = %{value: :up}

      assert {:ok, %PostVote{} = post_vote} = Votes.create_post_vote(valid_attrs)
      assert post_vote.value == :up
    end

    test "create_post_vote/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Votes.create_post_vote(@invalid_attrs)
    end

    test "update_post_vote/2 with valid data updates the post_vote" do
      post_vote = post_vote_fixture()
      update_attrs = %{value: :down}

      assert {:ok, %PostVote{} = post_vote} = Votes.update_post_vote(post_vote, update_attrs)
      assert post_vote.value == :down
    end

    test "update_post_vote/2 with invalid data returns error changeset" do
      post_vote = post_vote_fixture()
      assert {:error, %Ecto.Changeset{}} = Votes.update_post_vote(post_vote, @invalid_attrs)
      assert post_vote == Votes.get_post_vote!(post_vote.id)
    end

    test "delete_post_vote/1 deletes the post_vote" do
      post_vote = post_vote_fixture()
      assert {:ok, %PostVote{}} = Votes.delete_post_vote(post_vote)
      assert_raise Ecto.NoResultsError, fn -> Votes.get_post_vote!(post_vote.id) end
    end

    test "change_post_vote/1 returns a post_vote changeset" do
      post_vote = post_vote_fixture()
      assert %Ecto.Changeset{} = Votes.change_post_vote(post_vote)
    end
  end

  describe "comment_votes" do
    alias CutTheBullshit.Votes.CommentVote

    import CutTheBullshit.VotesFixtures

    @invalid_attrs %{value: nil}

    test "list_comment_votes/0 returns all comment_votes" do
      comment_vote = comment_vote_fixture()
      assert Votes.list_comment_votes() == [comment_vote]
    end

    test "get_comment_vote!/1 returns the comment_vote with given id" do
      comment_vote = comment_vote_fixture()
      assert Votes.get_comment_vote!(comment_vote.id) == comment_vote
    end

    test "create_comment_vote/1 with valid data creates a comment_vote" do
      valid_attrs = %{value: :up}

      assert {:ok, %CommentVote{} = comment_vote} = Votes.create_comment_vote(valid_attrs)
      assert comment_vote.value == :up
    end

    test "create_comment_vote/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Votes.create_comment_vote(@invalid_attrs)
    end

    test "update_comment_vote/2 with valid data updates the comment_vote" do
      comment_vote = comment_vote_fixture()
      update_attrs = %{value: :down}

      assert {:ok, %CommentVote{} = comment_vote} = Votes.update_comment_vote(comment_vote, update_attrs)
      assert comment_vote.value == :down
    end

    test "update_comment_vote/2 with invalid data returns error changeset" do
      comment_vote = comment_vote_fixture()
      assert {:error, %Ecto.Changeset{}} = Votes.update_comment_vote(comment_vote, @invalid_attrs)
      assert comment_vote == Votes.get_comment_vote!(comment_vote.id)
    end

    test "delete_comment_vote/1 deletes the comment_vote" do
      comment_vote = comment_vote_fixture()
      assert {:ok, %CommentVote{}} = Votes.delete_comment_vote(comment_vote)
      assert_raise Ecto.NoResultsError, fn -> Votes.get_comment_vote!(comment_vote.id) end
    end

    test "change_comment_vote/1 returns a comment_vote changeset" do
      comment_vote = comment_vote_fixture()
      assert %Ecto.Changeset{} = Votes.change_comment_vote(comment_vote)
    end
  end
end

defmodule CutTheBullshitWeb.CommentVoteLiveTest do
  use CutTheBullshitWeb.ConnCase

  import Phoenix.LiveViewTest
  import CutTheBullshit.VotesFixtures

  @create_attrs %{value: :up}
  @update_attrs %{value: :down}
  @invalid_attrs %{value: nil}

  defp create_comment_vote(_) do
    comment_vote = comment_vote_fixture()
    %{comment_vote: comment_vote}
  end

  describe "Index" do
    setup [:create_comment_vote]

    test "lists all comment_votes", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.comment_vote_index_path(conn, :index))

      assert html =~ "Listing Comment votes"
    end

    test "saves new comment_vote", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.comment_vote_index_path(conn, :index))

      assert index_live |> element("a", "New Comment vote") |> render_click() =~
               "New Comment vote"

      assert_patch(index_live, Routes.comment_vote_index_path(conn, :new))

      assert index_live
             |> form("#comment_vote-form", comment_vote: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#comment_vote-form", comment_vote: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.comment_vote_index_path(conn, :index))

      assert html =~ "Comment vote created successfully"
    end

    test "updates comment_vote in listing", %{conn: conn, comment_vote: comment_vote} do
      {:ok, index_live, _html} = live(conn, Routes.comment_vote_index_path(conn, :index))

      assert index_live |> element("#comment_vote-#{comment_vote.id} a", "Edit") |> render_click() =~
               "Edit Comment vote"

      assert_patch(index_live, Routes.comment_vote_index_path(conn, :edit, comment_vote))

      assert index_live
             |> form("#comment_vote-form", comment_vote: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#comment_vote-form", comment_vote: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.comment_vote_index_path(conn, :index))

      assert html =~ "Comment vote updated successfully"
    end

    test "deletes comment_vote in listing", %{conn: conn, comment_vote: comment_vote} do
      {:ok, index_live, _html} = live(conn, Routes.comment_vote_index_path(conn, :index))

      assert index_live |> element("#comment_vote-#{comment_vote.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#comment_vote-#{comment_vote.id}")
    end
  end

  describe "Show" do
    setup [:create_comment_vote]

    test "displays comment_vote", %{conn: conn, comment_vote: comment_vote} do
      {:ok, _show_live, html} = live(conn, Routes.comment_vote_show_path(conn, :show, comment_vote))

      assert html =~ "Show Comment vote"
    end

    test "updates comment_vote within modal", %{conn: conn, comment_vote: comment_vote} do
      {:ok, show_live, _html} = live(conn, Routes.comment_vote_show_path(conn, :show, comment_vote))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Comment vote"

      assert_patch(show_live, Routes.comment_vote_show_path(conn, :edit, comment_vote))

      assert show_live
             |> form("#comment_vote-form", comment_vote: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#comment_vote-form", comment_vote: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.comment_vote_show_path(conn, :show, comment_vote))

      assert html =~ "Comment vote updated successfully"
    end
  end
end

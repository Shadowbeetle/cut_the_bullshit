defmodule CutTheBullshitWeb.PostVoteLiveTest do
  use CutTheBullshitWeb.ConnCase

  import Phoenix.LiveViewTest
  import CutTheBullshit.VotesFixtures

  @create_attrs %{value: :up}
  @update_attrs %{value: :down}
  @invalid_attrs %{value: nil}

  defp create_post_vote(_) do
    post_vote = post_vote_fixture()
    %{post_vote: post_vote}
  end

  describe "Index" do
    setup [:create_post_vote]

    test "lists all post_votes", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.post_vote_index_path(conn, :index))

      assert html =~ "Listing Post votes"
    end

    test "saves new post_vote", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.post_vote_index_path(conn, :index))

      assert index_live |> element("a", "New Post vote") |> render_click() =~
               "New Post vote"

      assert_patch(index_live, Routes.post_vote_index_path(conn, :new))

      assert index_live
             |> form("#post_vote-form", post_vote: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#post_vote-form", post_vote: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.post_vote_index_path(conn, :index))

      assert html =~ "Post vote created successfully"
    end

    test "updates post_vote in listing", %{conn: conn, post_vote: post_vote} do
      {:ok, index_live, _html} = live(conn, Routes.post_vote_index_path(conn, :index))

      assert index_live |> element("#post_vote-#{post_vote.id} a", "Edit") |> render_click() =~
               "Edit Post vote"

      assert_patch(index_live, Routes.post_vote_index_path(conn, :edit, post_vote))

      assert index_live
             |> form("#post_vote-form", post_vote: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#post_vote-form", post_vote: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.post_vote_index_path(conn, :index))

      assert html =~ "Post vote updated successfully"
    end

    test "deletes post_vote in listing", %{conn: conn, post_vote: post_vote} do
      {:ok, index_live, _html} = live(conn, Routes.post_vote_index_path(conn, :index))

      assert index_live |> element("#post_vote-#{post_vote.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#post_vote-#{post_vote.id}")
    end
  end

  describe "Show" do
    setup [:create_post_vote]

    test "displays post_vote", %{conn: conn, post_vote: post_vote} do
      {:ok, _show_live, html} = live(conn, Routes.post_vote_show_path(conn, :show, post_vote))

      assert html =~ "Show Post vote"
    end

    test "updates post_vote within modal", %{conn: conn, post_vote: post_vote} do
      {:ok, show_live, _html} = live(conn, Routes.post_vote_show_path(conn, :show, post_vote))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Post vote"

      assert_patch(show_live, Routes.post_vote_show_path(conn, :edit, post_vote))

      assert show_live
             |> form("#post_vote-form", post_vote: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#post_vote-form", post_vote: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.post_vote_show_path(conn, :show, post_vote))

      assert html =~ "Post vote updated successfully"
    end
  end
end

defmodule CutTheBullshit.SearchTest do
  use CutTheBullshit.DataCase

  alias CutTheBullshit.Search

  describe "query" do
    alias CutTheBullshit.Search.Query

    import CutTheBullshit.SearchFixtures

    @invalid_attrs %{term: nil}

    test "list_query/0 returns all query" do
      query = query_fixture()
      assert Search.list_query() == [query]
    end

    test "get_query!/1 returns the query with given id" do
      query = query_fixture()
      assert Search.get_query!(query.id) == query
    end

    test "create_query/1 with valid data creates a query" do
      valid_attrs = %{term: "some term"}

      assert {:ok, %Query{} = query} = Search.create_query(valid_attrs)
      assert query.term == "some term"
    end

    test "create_query/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Search.create_query(@invalid_attrs)
    end

    test "update_query/2 with valid data updates the query" do
      query = query_fixture()
      update_attrs = %{term: "some updated term"}

      assert {:ok, %Query{} = query} = Search.update_query(query, update_attrs)
      assert query.term == "some updated term"
    end

    test "update_query/2 with invalid data returns error changeset" do
      query = query_fixture()
      assert {:error, %Ecto.Changeset{}} = Search.update_query(query, @invalid_attrs)
      assert query == Search.get_query!(query.id)
    end

    test "delete_query/1 deletes the query" do
      query = query_fixture()
      assert {:ok, %Query{}} = Search.delete_query(query)
      assert_raise Ecto.NoResultsError, fn -> Search.get_query!(query.id) end
    end

    test "change_query/1 returns a query changeset" do
      query = query_fixture()
      assert %Ecto.Changeset{} = Search.change_query(query)
    end
  end
end

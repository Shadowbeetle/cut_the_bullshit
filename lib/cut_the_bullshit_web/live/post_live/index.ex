defmodule CutTheBullshitWeb.PostLive.Index do
  use CutTheBullshitWeb, :live_view

  alias CutTheBullshit.Posts
  alias CutTheBullshit.Posts.Post
  alias CutTheBullshit.Search.Query

  alias CutTheBullshitWeb.PostLive.PostComponent

  require Logger

  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket) |> Surface.init()

    Logger.info(inspect(&PostComponent.render/1))

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    page = if is_nil(params["page"]), do: 1, else: params["page"] |> String.to_integer()
    order_by = if is_nil(params["order_by"]), do: "latest", else: params["order_by"]

    {:noreply,
     apply_action(socket, socket.assigns.live_action, params)
     |> assign(:posts, list_posts(socket.assigns, page, order_by))
     |> assign(:search_changeset, Query.changeset(%Query{}, %{"term" => ""}))
     |> assign(:page, page)
     |> assign(:order_by, order_by)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Post")
    |> assign(:post, Posts.get_post!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Post")
    |> assign(:post, %Post{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Posts")
    |> assign(:post, nil)
  end

  @impl true

  def handle_event("search", %{"query" => query}, socket) do
    current_search = socket.assigns.search_changeset |> Ecto.Changeset.apply_changes()

    {:noreply,
     socket
     |> assign(
       :search_changeset,
       Query.changeset(current_search, %{"term" => query["term"]})
     )
     |> assign(:posts, search_posts(socket.assigns, query["term"]))}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    post = Posts.get_post!(id)
    {:ok, _} = Posts.delete_post(post)

    {:noreply,
     socket
     |> put_flash(:info, "Post deleted")
     |> assign(
       :posts,
       list_posts(socket.assigns.current_user, socket.assigns.page, socket.assigns.order_by)
     )}
  end

  defp list_posts(assigns, page, order_by) do
    if Map.has_key?(assigns, :current_user) and not is_nil(assigns.current_user) do
      Posts.list_posts(assigns.current_user, page, order_by)
    else
      Posts.list_posts(page, order_by)
    end
  end

  defp search_posts(assigns, query_term) do
    if Map.has_key?(assigns, :current_user) and not is_nil(assigns.current_user) do
      Posts.search_posts_by_name(assigns.current_user, query_term)
    else
      Posts.search_posts_by_name(query_term)
    end
  end
end

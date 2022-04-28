defmodule CutTheBullshitWeb.PostLive.Index do
  use CutTheBullshitWeb, :live_view

  alias CutTheBullshit.Posts
  alias CutTheBullshit.Posts.Post

  require Logger

  @impl true
  def mount(_params, session, socket) do
    {:ok,
     assign_defaults(session, socket)
     |> assign(:posts, list_posts(socket.assigns))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
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
    |> assign(:page_title, "Listing Posts")
    |> assign(:post, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    post = Posts.get_post!(id)
    {:ok, _} = Posts.delete_post(post)

    {:noreply, assign(socket, :posts, list_posts(socket.assigns.current_user))}
  end

  defp list_posts(assigns) do
    Logger.info("mounting with socket: #{inspect(assigns |> Map.keys())}")

    if Map.has_key?(assigns, :current_user) do
      Posts.list_posts_with_users_upvotes(assigns.current_user.id)
    else
      Posts.list_posts()
    end
  end
end

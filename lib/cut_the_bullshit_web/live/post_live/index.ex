defmodule CutTheBullshitWeb.PostLive.Index do
  use CutTheBullshitWeb, :live_view

  alias CutTheBullshit.Posts
  alias CutTheBullshit.Posts.Post

  require Logger

  @impl true
  def mount(_params, session, socket) do
    socket = assign_defaults(session, socket)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    page = if is_nil(params["page"]), do: 1, else: params["page"] |> String.to_integer()

    {:noreply,
     apply_action(socket, socket.assigns.live_action, params)
     |> assign(:posts, list_posts(socket.assigns, page))
     |> assign(:page, page)}
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

    {:noreply,
     assign(socket, :posts, list_posts(socket.assigns.current_user, socket.assigns.page))}
  end

  defp list_posts(assigns, page) do
    if Map.has_key?(assigns, :current_user) and not is_nil(assigns.current_user) do
      Posts.list_posts(assigns.current_user, page)
    else
      Posts.list_posts(page)
    end
  end
end

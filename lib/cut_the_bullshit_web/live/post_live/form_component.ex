defmodule CutTheBullshitWeb.PostLive.FormComponent do
  use CutTheBullshitWeb, :live_component

  alias CutTheBullshit.Posts
  alias CutTheBullshit.Votes
  require Logger

  @impl true
  def update(%{post: post} = assigns, socket) do
    changeset = Posts.change_post(post)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"post" => post_params}, socket) do
    params = Map.put(post_params, "user_id", socket.assigns.current_user.id)

    changeset =
      socket.assigns.post
      |> Posts.change_post(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"post" => post_params}, socket) do
    params = Map.put(post_params, "user_id", socket.assigns.current_user.id)
    save_post(socket, socket.assigns.action, params)
  end

  defp save_post(socket, :edit, params) do
    case Posts.update_post(socket.assigns.post, params) do
      {:ok, _post} ->
        {:noreply,
         socket
         |> put_flash(:info, "Post updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_post(socket, :new, params) do
    result =
      with {:ok, post} <- Posts.create_post(params),
           do:
             Votes.create_post_vote(%{
               "post_id" => post.id,
               "user_id" => socket.assigns.current_user.id,
               "value" => :up
             })

    case result do
      {:ok, _vote} ->
        {:noreply,
         socket
         |> put_flash(:info, "Post created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

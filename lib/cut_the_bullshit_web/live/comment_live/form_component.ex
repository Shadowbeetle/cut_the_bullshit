defmodule CutTheBullshitWeb.CommentLive.FormComponent do
  use Surface.LiveComponent

  alias Surface.Components.Form
  alias Surface.Components.Form.TextArea
  alias Surface.Components.Form.Label
  alias Surface.Components.Form.ErrorTag

  alias CutTheBullshit.Comments

  require Logger

  @impl true
  def update(%{comment: comment} = assigns, socket) do
    changeset = Comments.change_comment(comment)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"comment" => comment_params}, socket) do
    params =
      comment_params
      |> Map.put("user_id", socket.assigns.current_user.id)
      |> Map.put("post_id", socket.assigns.post.id)

    changeset =
      socket.assigns.comment
      |> Comments.change_comment(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"comment" => comment_params}, socket) do
    params =
      comment_params
      |> Map.put("user_id", socket.assigns.current_user.id)
      |> Map.put("post_id", socket.assigns.post.id)

    save_comment(socket, socket.assigns.action, params)
  end

  defp save_comment(socket, :edit_comment, params) do
    case Comments.update_comment(socket.assigns.comment, params) do
      {:ok, _comment} ->
        {:noreply,
         socket
         |> put_flash(:info, "Comment updated successfully")
         |> push_redirect(to: socket.assigns.return_to, replace: true)}

      {:error, _, %Ecto.Changeset{} = changeset, _} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_comment(socket, :new_comment, params) do
    case Comments.create_comment(socket.assigns.post, params) do
      {:ok, %{comment: _, vote: _}} ->
        {:noreply,
         socket
         |> put_flash(:info, "Comment created successfully")
         |> push_redirect(to: socket.assigns.return_to replace: true)}

      {:error, _, %Ecto.Changeset{} = changeset, _} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

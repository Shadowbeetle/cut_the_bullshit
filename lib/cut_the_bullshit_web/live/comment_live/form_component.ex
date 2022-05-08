defmodule CutTheBullshitWeb.CommentLive.FormComponent do
  use Surface.LiveComponent

  alias Surface.Components.Form
  alias Surface.Components.Form.TextArea
  alias Surface.Components.Form.ErrorTag

  alias CutTheBullshit.Comments
  alias CutTheBullshitWeb.Router.Helpers, as: Routes

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
    current_user = socket.assigns.current_user
    post = socket.assigns.post

    params =
      comment_params
      |> Map.put("user_id", if(is_nil(current_user), do: nil, else: current_user.id))
      |> Map.put("post_id", post.id)

    changeset =
      socket.assigns.comment
      |> Comments.change_comment(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"comment" => comment_params}, socket) do
    if socket.assigns.current_user do
      params =
        comment_params
        |> Map.put("user_id", socket.assigns.current_user.id)
        |> Map.put("post_id", socket.assigns.post.id)

      save_comment(socket, socket.assigns.action, params)
    else
      {:noreply,
       socket
       |> redirect(to: Routes.user_session_path(socket, :new))}
    end
  end

  defp save_comment(socket, :edit_comment, params) do
    case Comments.update_comment(socket.assigns.comment, params) do
      {:ok, comment} ->
        {:noreply,
         socket
         |> put_flash(:info, "Comment updated successfully")
         |> push_redirect(to: socket.assigns.return_to <> "#comment-#{comment.id}", replace: true)}

      {:error, _, %Ecto.Changeset{} = changeset, _} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_comment(socket, :new_comment, params) do
    case Comments.create_comment(socket.assigns.post, params) do
      {:ok, %{comment: comment, vote: _}} ->
        {:noreply,
         socket
         |> put_flash(:info, "Comment created successfully")
         |> push_redirect(to: socket.assigns.return_to <> "#comment-#{comment.id}", replace: true)}

      {:error, _, %Ecto.Changeset{} = changeset, _} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

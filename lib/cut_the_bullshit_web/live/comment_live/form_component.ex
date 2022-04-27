defmodule CutTheBullshitWeb.CommentLive.FormComponent do
  use CutTheBullshitWeb, :live_component

  alias CutTheBullshit.Comments
  alias CutTheBullshit.Votes

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
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_comment(socket, :new_comment, params) do
    result =
      with {:ok, comment} <- Comments.create_comment(params),
           do:
             Votes.create_comment_vote(%{
               "comment_id" => comment.id,
               "user_id" => socket.assigns.current_user.id,
               "value" => :up
             })

    case result do
      {:ok, _comment} ->
        {:noreply,
         socket
         |> put_flash(:info, "Comment created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end

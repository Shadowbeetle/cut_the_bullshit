defmodule CutTheBullshitWeb.UserLive.Show do
  use CutTheBullshitWeb, :live_view

  alias CutTheBullshit.Accounts

  require Logger

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_defaults(session, socket)}
  end

  @impl true

  def handle_params(%{"id" => id} = _params, _, socket) do
    user = Accounts.get_user!(id)

    {:noreply,
     socket
     |> assign(:user, user)
     |> assign(:page_title, "#{user.username}'s Profile")}
  end
end

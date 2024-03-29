defmodule CutTheBullshitWeb.LiveHelpers do
  import Phoenix.LiveView
  import Phoenix.LiveView.Helpers

  alias Phoenix.LiveView.JS

  alias CutTheBullshit.Accounts
  alias CutTheBullshit.Accounts.User
  require Logger

  @doc """
  Renders a live component inside a modal.

  The rendered modal receives a `:return_to` option to properly update
  the URL when the modal is closed.

  ## Examples

      <.modal return_to={Routes.post_index_path(@socket, :index)}>
        <.live_component
          module={CutTheBullshitWeb.PostLive.FormComponent}
          id={@post.id || :new}
          title={@page_title}
          action={@live_action}
          return_to={Routes.post_index_path(@socket, :index)}
          post: @post
        />
      </.modal>
  """
  def modal(assigns) do
    assigns = assign_new(assigns, :return_to, fn -> nil end)

    ~H"""
    <div id="modal" class="phx-modal fade-in" phx-remove={hide_modal()}>
      <div
        id="modal-content"
        class="phx-modal-content fade-in-scale"
        phx-click-away={JS.dispatch("click", to: "#close")}
        phx-window-keydown={JS.dispatch("click", to: "#close")}
        phx-key="escape"
      >
        <%= if @return_to do %>
          <%= live_patch "✖",
            to: @return_to,
            id: "close",
            class: "phx-modal-close",
            phx_click: hide_modal(),
            replace: true
          %>
        <% else %>
          <a id="close" href="#" class="phx-modal-close" phx-click={hide_modal()}>✖</a>
        <% end %>

        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  defp hide_modal(js \\ %JS{}) do
    js
    |> JS.hide(to: "#modal", transition: "fade-out")
    |> JS.hide(to: "#modal-content", transition: "fade-out-scale")
  end

  def assign_defaults(session, socket) do
    _socket =
      assign_new(socket, :current_user, fn ->
        find_current_user(session)
      end)
  end

  defp find_current_user(session) do
    with user_token when not is_nil(user_token) <- session["user_token"],
         %User{} = user <- Accounts.get_user_by_session_token(user_token),
         do: user
  end

  def is_logged_in(current_user) do
    not is_nil(current_user)
  end

  def is_same_user(user, current_user) do
    user == current_user
  end

  def get_humanized_time_difference(%NaiveDateTime{} = time1, %NaiveDateTime{} = time2) do
    NaiveDateTime.diff(time1, time2)
    |> Timex.Duration.from_seconds()
    |> Timex.Format.Duration.Formatters.Humanized.format()
    |> String.replace(~r",.+$", "")
    |> Kernel.<>(" ago")
  end

  def newlines_to_html(text) do
    text
    |> String.split(~r"\n{2,}")
    |> Enum.map(fn paragraph ->
      assigns = %{p: paragraph}

      ~H"""
        <p>
          <%= for i <- String.split(@p, "\n") do %>
            <%= i %><br/>
          <% end %>
        </p>
      """
    end)
  end
end

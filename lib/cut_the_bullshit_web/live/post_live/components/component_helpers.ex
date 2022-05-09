defmodule CutTheBullshitWeb.PostLive.ComponentHelpers do
  use CutTheBullshitWeb, :component

  require Logger

  def post_component(assigns) do
    ~H"""
    <div id={"post-#{@post.id}"} style="display: flex; border-bottom: 0.5px solid rgb(128 128 128 / 20%);">
      <div>
        <.live_component
          module={CutTheBullshitWeb.PostLive.VoteComponent}
          id={"vote-#{@post.id}"}
          content={@post}
          current_user={@current_user}/>
      </div>
      <div style="margin-left: 15px;display: flex;flex-direction: column;justify-content: center;">
        <div>
          <span><%= live_redirect @post.title, to: @post_show_path %></span>
          <%= if @post.url do %>
            <span>| <%= link "[website]", to: @post.url %></span>
          <% end %>
        </div>
        <div class="info-line">
          <span>
            by <%= live_redirect @post.user.username,
                                to: Routes.user_show_path(CutTheBullshitWeb.Endpoint, :show, @post.user_id) %>
          </span>
          <span><%= get_humanized_time_difference(NaiveDateTime.utc_now(), @post.inserted_at) %></span>
          <span>| <%= live_redirect @post.comment_count, to: @post_show_path %> comments </span>
          <%= if is_same_user(@current_user, @post.user) do %>
            <span>| <%= live_patch "Edit", to: @post_edit_path %></span>
            <span>| <%= link "Delete", to: "#", phx_click: "delete", phx_value_id: @post.id,
                                       data: [confirm: "Are you sure?"] %></span>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end

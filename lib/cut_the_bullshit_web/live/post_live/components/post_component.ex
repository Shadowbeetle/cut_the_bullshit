defmodule CutTheBullshitWeb.PostLive.PostComponent do
  use CutTheBullshitWeb, :component

  def post_row(assigns) do
    ~H"""
    <tr id={"post-#{@post.id}"}>
      <td><%= @post.title %></td>
      <td><%= @post.url %></td>
      <td><%= @post.user.username %></td>
      <td><%= @post.comment_count %></td>
      <td>
        <.live_component
          module={CutTheBullshitWeb.PostLive.VoteComponent}
          id={"vote-#{@post.id}"}
          content={@post}
          current_user={@current_user}
        />
      </td>

      <td>
        <span><%= live_redirect "Show", to: @post_show_path %></span>
        <%= if is_same_user(@current_user, @post.user) do %>
          <span><%= live_patch "Edit", to: @post_edit_path %></span>
          <span><%= link "Delete", to: "#", phx_click: "delete", phx_value_id: @post.id, data: [confirm: "Are you sure?"] %></span>
        <% end %>
      </td>
    </tr>
    """
  end
end

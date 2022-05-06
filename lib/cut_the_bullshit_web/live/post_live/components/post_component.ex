defmodule CutTheBullshitWeb.PostLive.PostComponent do
  use Surface.Component
  import CutTheBullshitWeb.LiveHelpers

  alias Surface.Components.{Link, LivePatch, LiveRedirect}

  prop post, :struct, required: true
  prop current_user, :struct, required: true
  prop post_show_path, :string, required: true
  prop post_edit_path, :string, required: true

  @impl true
  def render(assigns) do
    ~F"""
    <tr id={"post-#{@post.id}"}>
      <td>{@post.title}</td>
      <td>{@post.url}</td>
      <td>{@post.user.username}</td>
      <td>{@post.comment_count}</td>
      <td>
        {live_component CutTheBullshitWeb.PostLive.VoteComponent,
          id: "vote-#{@post.id}",
          content: @post,
          current_user: @current_user}
      </td>

      <td>
        <span><LiveRedirect to={@post_show_path}>Show</LiveRedirect></span>
        {#if is_same_user(@current_user, @post.user)}
          <span><LivePatch to={@post_edit_path}>Edit</LivePatch></span>
          <span><Link to={"#"} opts={phx_click: "delete", phx_value_id: @post.id, data: [confirm: "Are you sure?"]}>Delete</Link></span>
        {/if}
      </td>
    </tr>
    """
  end
end

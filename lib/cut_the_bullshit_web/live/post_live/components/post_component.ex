defmodule CutTheBullshitWeb.PostLive.PostComponent do
  use Surface.Component
  import CutTheBullshitWeb.LiveHelpers

  alias Surface.Components.{Link, LivePatch, LiveRedirect}

  require Logger

  prop(post, :struct, required: true)
  prop(current_user, :struct, required: true)
  prop(post_show_path, :string, required: true)
  prop(post_edit_path, :string, required: true)

  @impl true
  def render(assigns) do
    ~F"""
    <tr id={"post-#{@post.id}"}>
      <td>
        {live_component CutTheBullshitWeb.PostLive.VoteComponent,
          id: "vote-#{@post.id}",
          content: @post,
          current_user: @current_user}
      </td>
      <td>
        <div>
          <LiveRedirect to={@post_show_path}>{@post.title}</LiveRedirect>
          <Link :if={@post.url} to={@post.url}>[Website]</Link>
        </div>
        <div>
          <span>by {@post.user.username}</span>
          <span>{get_humanized_time_difference(NaiveDateTime.utc_now(), @post.inserted_at)}</span>
          <span>| <LiveRedirect to={@post_show_path}>{@post.comment_count} comments</LiveRedirect></span>
          {#if is_same_user(@current_user, @post.user)}
            | <span><LivePatch to={@post_edit_path}>Edit</LivePatch></span>
            | <span><Link to="#" opts={phx_click: "delete", phx_value_id: @post.id, data: [confirm: "Are you sure?"]}>Delete</Link></span>
          {/if}
        </div>
      </td>
    </tr>
    """
  end
end

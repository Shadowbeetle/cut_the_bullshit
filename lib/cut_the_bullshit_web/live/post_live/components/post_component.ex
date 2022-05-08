defmodule CutTheBullshitWeb.PostLive.PostComponent do
  use Surface.Component
  import CutTheBullshitWeb.LiveHelpers

  alias Surface.Components.{Link, LivePatch, LiveRedirect}
  alias CutTheBullshitWeb.Router.Helpers, as: Routes

  require Logger

  prop(post, :struct, required: true)
  prop(current_user, :struct, required: true)
  prop(post_show_path, :string, required: true)
  prop(post_edit_path, :string, required: true)

  @impl true
  def render(assigns) do
    ~F"""
    <div id={"post-#{@post.id}"} style="display: flex; border-bottom: 0.5px solid rgb(128 128 128 / 20%);">
      <div>
        {live_component CutTheBullshitWeb.PostLive.VoteComponent,
          id: "vote-#{@post.id}",
          content: @post,
          current_user: @current_user}
      </div>
      <div style="margin-left: 15px;display: flex;flex-direction: column;justify-content: center;">
        <div>
          <span><LiveRedirect to={@post_show_path}>{@post.title}</LiveRedirect></span>
          <span :if={@post.url}>| <Link  to={@post.url}>[Website]</Link></span>
        </div>
        <div class="info-line">
          <span>
            by <LiveRedirect to={Routes.user_show_path(CutTheBullshitWeb.Endpoint, :show, @post.user_id)}>
              {@post.user.username}
            </LiveRedirect>
          </span>
          <span>{get_humanized_time_difference(NaiveDateTime.utc_now(), @post.inserted_at)}</span>
          <span>| <LiveRedirect to={@post_show_path}>{@post.comment_count} comments</LiveRedirect></span>
          {#if is_same_user(@current_user, @post.user)}
            <span>| <LivePatch to={@post_edit_path}>Edit</LivePatch></span>
            <span>| <Link to="#" opts={phx_click: "delete", phx_value_id: @post.id, data: [confirm: "Are you sure?"]}>Delete</Link></span>
          {/if}
        </div>
      </div>
    </div>
    """
  end
end

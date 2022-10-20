defmodule LiveCursorsWeb.Cursors do
  alias LiveCursorsWeb.Presence
  use LiveCursorsWeb, :live_view

  @channel_topic "cursor_page"

  def mount(_params, %{"user" => user}, socket) do
    Presence.track(self(), @channel_topic, socket.id, %{
      socket_id: socket.id,
      x: 50,
      y: 50,
      name: user
    })

    LiveCursorsWeb.Endpoint.subscribe(@channel_topic)

    initial_users =
      Presence.list(@channel_topic)
      |> Enum.map(fn {_, data} -> data[:metas] |> List.first() end)

    updated =
      socket
      |> assign(:user, user)
      |> assign(:users, initial_users)
      |> assign(:socket_id, socket.id)

    {:ok, updated}
  end

  def mount(_params, _session, socket) do
    {:ok, socket |> redirect(to: "/") }
  end

  def handle_event("cursor-move", %{"mouse_x" => x, "mouse_y" => y}, socket) do
    key = socket.id
    payload = %{x: x, y: y}

    metas =
      Presence.get_by_key(@channel_topic, key)[:metas]
      |> List.first()
      |> Map.merge(payload)

    Presence.update(self(), @channel_topic, key, metas)

    {:noreply, socket}
  end

  def handle_info(%{event: "presence_diff", payload: _payload}, socket) do
    users =
      Presence.list(@channel_topic)
      |> Enum.map(fn {_, data} -> data[:metas] |> List.first() end)

    updated =
      socket
      |> assign(users: users)
      |> assign(socket_id: socket.id)

    {:noreply, updated}
  end

  def render(assigns) do
    ~H"""
      <ul class="list-none" id="cursor" phx-hook="TrackClientCursor">
        <%= for user <- @users do %>
          <li style={"color: deeppink; left: #{user.x}%; top: #{user.y}%"} class="flex flex-col absolute pointer-events-none whitespace-nowrap overflow-hidden">
          <svg xmlns="http://www.w3.org/2000/svg" width="31" height="32" fill="none" viewBox="0 0 31 32">
                <path fill="url(#a)" d="m.609 10.86 5.234 15.488c1.793 5.306 8.344 7.175 12.666 3.612l9.497-7.826c4.424-3.646 3.69-10.625-1.396-13.27L11.88 1.2C5.488-2.124-1.697 4.033.609 10.859Z"/>
                <defs>
                  <linearGradient id="a" x1="-4.982" x2="23.447" y1="-8.607" y2="25.891" gradientUnits="userSpaceOnUse">
                    <stop stop-color="#FF44F8"/>
                    <stop offset="1" stop-color="#BDACFF"/>
                  </linearGradient>
                </defs>
              </svg>
            <span style={"background-color: deeppink;"} class="mt-1 ml-4 px-1 text-sm text-white">
              <%= user.name %>
            </span>
          </li>
        <% end %>
      </ul>
    """
  end
end

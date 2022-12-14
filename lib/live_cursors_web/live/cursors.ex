defmodule LiveCursorsWeb.Cursors do
  alias LiveCursorsWeb.AuthController
  alias LiveCursorsWeb.Presence
  use LiveCursorsWeb, :live_view

  @channel_topic "cursor_page"

  def mount(params, session, socket) do
    # Add auth assigns to socket
    {_cont, socket} = AuthController.add_assigns(:default, params, session, socket)

    username =
      if socket.assigns.loggedin do
        socket.assigns.person.username || socket.assigns.person.givenName || "guest"
      else
        MnemonicSlugs.generate_slug()
      end

    color = RandomColor.hex()

    Presence.track(self(), @channel_topic, socket.id, %{
      socket_id: socket.id,
      x: 50,
      y: 50,
      username: username,
      color: color
    })

    LiveCursorsWeb.Endpoint.subscribe(@channel_topic)

    initial_users =
      Presence.list(@channel_topic)
      |> Enum.map(fn {_, data} -> data[:metas] |> List.first() end)

    updated =
      socket
      |> assign(:username, username)
      |> assign(:users, initial_users)
      |> assign(:socket_id, socket.id)

    {:ok, updated}
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

  def handle_event("login", _value, socket) do
    {:noreply, push_redirect(socket, to: "/login")}
  end

  def handle_event("logout", _value, socket) do
    {:noreply, push_redirect(socket, to: "/logout")}
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
end

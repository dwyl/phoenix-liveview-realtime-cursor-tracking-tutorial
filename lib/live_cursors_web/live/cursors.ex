defmodule LiveCursorsWeb.Cursors do
  use LiveCursorsWeb, :live_view

  def mount(_params, %{"user" => user}, socket) do
    updated =
      socket
      |> assign(:mouse_x, 50)
      |> assign(:mouse_y, 50)
      |> assign(:user, user)

    {:ok, updated}
  end

  def mount(_params, _session, socket) do
    {:ok, socket |> redirect(to: "/") }
  end

  def handle_event("cursor-move", %{"mouse_x" => mouse_x, "mouse_y" => mouse_y}, socket) do
    updated =
      socket
      |> assign(:mouse_x, mouse_x)
      |> assign(:mouse_y, mouse_y)

    {:noreply, updated}
  end

  def render(assigns) do
    ~H"""
      <ul class="list-none" id="cursor" phx-hook="TrackClientCursor">
        <li style={"color: deeppink; left: #{@mouse_x}%; top: #{@mouse_y}%"} class="flex flex-col absolute pointer-events-none whitespace-nowrap overflow-hidden">
          <svg xmlns="http://www.w3.org/2000/svg" width="31" height="32" fill="none" viewBox="0 0 31 32">
            <path fill="url(#a)" d="m.609 10.86 5.234 15.488c1.793 5.306 8.344 7.175 12.666 3.612l9.497-7.826c4.424-3.646 3.69-10.625-1.396-13.27L11.88 1.2C5.488-2.124-1.697 4.033.609 10.859Z"/>
            <defs>
              <linearGradient id="a" x1="-4.982" x2="23.447" y1="-8.607" y2="25.891" gradientUnits="userSpaceOnUse">
                <stop stop-color="#FF44F8"/>
                <stop offset="1" stop-color="#BDACFF"/>
              </linearGradient>
            </defs>
          </svg>
          <span style={"background-color: deeppink;"} class="mt-1 ml-4 px-1 text-sm text-white"><%= @user %></span>
        </li>
      </ul>
    """
  end
end

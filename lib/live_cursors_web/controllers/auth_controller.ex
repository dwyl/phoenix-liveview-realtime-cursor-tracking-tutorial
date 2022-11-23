defmodule LiveCursorsWeb.AuthController do
  use LiveCursorsWeb, :controller
  import Phoenix.LiveView, only: [assign_new: 3]

  def add_assigns(:default, _params, %{"jwt" => jwt} = _session, socket) do

    claims = jwt
    |> AuthPlug.Token.verify_jwt!()
    |> AuthPlug.Helpers.strip_struct_metadata()
    |> Useful.atomize_map_keys()

    socket =
      socket
      |> assign_new(:person, fn -> claims end)
      |> assign_new(:loggedin, fn -> true end)


    {:cont, socket}
  end

  def add_assigns(:default, _params, _session, socket) do
    socket = assign_new(socket, :loggedin, fn -> false end)
    {:cont, socket}
  end

  def login(conn, _params) do
    redirect(conn, external: AuthPlug.get_auth_url(conn, "/"))
  end

  def logout(conn, _params) do
    conn
    |> AuthPlug.logout()
    |> put_status(302)
    |> redirect(to: "/")
  end
end

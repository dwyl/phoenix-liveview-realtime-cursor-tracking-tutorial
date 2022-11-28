defmodule LiveCursorsWeb.AuthController do
  use LiveCursorsWeb, :controller
  import Phoenix.LiveView, only: [assign_new: 3]

  def add_assigns(:default, _params, %{"jwt" => jwt} = _session, socket) do
    {:cont, AuthPlug.assign_jwt_to_socket(socket, &assign_new/3, jwt)}
  end

  # if there's no JWT present, then set :loggedin to false
  def add_assigns(:default, _params, _session, socket) do
    {:cont, assign_new(socket, :loggedin, fn -> false end)}
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

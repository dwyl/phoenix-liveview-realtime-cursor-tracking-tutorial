defmodule LiveCursorsWeb.PageController do
  use LiveCursorsWeb, :controller

  def index(conn, _params) do
    session = conn |> get_session()

    case session do
      %{"user" => _user} ->
        conn
        |> redirect(to: "/cursors")

      _ ->
        conn
        |> put_session(:user, MnemonicSlugs.generate_slug)
        |> configure_session(renew: true)
        |> redirect(to: "/cursors")
    end
  end
end

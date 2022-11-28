defmodule LiveCursorsWeb.AuthControllerTest do
  alias LiveCursorsWeb.AuthController
  use LiveCursorsWeb.ConnCase

  test "Logout link displayed when loggedin", %{conn: conn} do
    data = %{
      email: "test@dwyl.com",
      givenName: "Simon",
      picture: "this",
      auth_provider: "GitHub",
      username: "SimonLabs"
    }

    jwt = AuthPlug.Token.generate_jwt!(data)

    conn = get(conn, "/?jwt=#{jwt}")
    assert html_response(conn, 200) =~ "logout"
  end

  test "get /logout with valid JWT", %{conn: conn} do
    data = %{
      email: "al@dwyl.com",
      givenName: "Al",
      picture: "this",
      auth_provider: "GitHub",
      sid: 1,
      id: 1
    }

    jwt = AuthPlug.Token.generate_jwt!(data)

    conn =
      conn
      |> put_req_header("authorization", jwt)
      |> get("/logout")

    assert "/" = redirected_to(conn, 302)
  end

  test "test login link redirect to authdemo.fly.dev", %{conn: conn} do
    conn = get(conn, "/login")
    assert redirected_to(conn, 302) =~ "authdemo.fly.dev"
  end

  test "test mount" do
    data = %{
      email: "test@dwyl.com",
      givenName: "Simon",
      picture: "this",
      auth_provider: "GitHub",
      username: "SimonLabs"
    }

    jwt = AuthPlug.Token.generate_jwt!(data)

    {:cont, socket} =
      AuthController.add_assigns(:default, nil, %{jwt: jwt}, %Phoenix.LiveView.Socket{})

    assert socket != nil
  end
end

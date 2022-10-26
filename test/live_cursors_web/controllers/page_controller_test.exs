defmodule LiveCursorsWeb.PageControllerTest do
  use LiveCursorsWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "just use your mouse"
  end
end

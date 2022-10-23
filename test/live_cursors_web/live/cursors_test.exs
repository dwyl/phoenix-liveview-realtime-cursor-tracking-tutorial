defmodule LiveCursorsWeb.CursorsTest do
  use LiveCursorsWeb.ConnCase
  use ExUnit.Case
  alias LiveCursorsWeb.Cursors
  require Logger

  defp create_socket() do
    %{socket: %Phoenix.LiveView.Socket{}}
  end

  describe "Socket state" do
    setup do
      create_socket()
    end

    test "when on mount assigns", %{socket: socket} do
      {:ok, socket} = Cursors.mount(nil, nil, socket)

      assert socket.assigns.username != ""
    end
  end
end

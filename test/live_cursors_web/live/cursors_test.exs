defmodule LiveCursorsWeb.CursorsTest do
  use LiveCursorsWeb.ConnCase
  use ExUnit.Case
  alias LiveCursorsWeb.Cursors
  import Mock

  # Default presence list response
  @presence_list_response %{"phx-FyEJCOx5vtCG6QAl" => %{metas: [%{color: "#035CA5", phx_ref: "FyEJCe_cOATybwvh", phx_ref_prev: "FyEJCe9jBIPybwvB", socket_id: "phx-FyEJCOx5vtCG6QAl", username: "tibet-nebula", x: 40.682870370370374, y: 23.435722411831627}]}}


  defp create_socket() do
    %{socket: %Phoenix.LiveView.Socket{}}
  end

  describe "Mount state" do
    setup do
      create_socket()
    end

    test "when on mount assigns", %{socket: socket} do
      {:ok, socket} = Cursors.mount(nil, nil, socket)

      assert socket.assigns.username != ""
    end

    test "when presence state changes", %{socket: socket} do

      with_mock LiveCursorsWeb.Presence,
        [list: fn(_list) -> @presence_list_response end] do

            payload = %Phoenix.Socket.Broadcast{
              topic: "cursor_page",
              event: "presence_diff",
              payload: %{
                joins: %{
                  "phx-FyEHJixUtfvtkBOD" => %{
                    metas: [%{
                      color: "#FFC9C4",
                      phx_ref: "FyEHJjOkomBpeQuH",
                      socket_id: "phx-FyEHJixUtfvtkBOD",
                      username: "magic-global",
                      x: 50,
                      y: 50}]
                      }
                    },
                leaves: %{}
                }
              }

            {:noreply, socket} = Cursors.handle_info(payload, socket)

            assert socket.assigns.socket_id != ""
            assert socket.assigns.users != []
          end
      end


  end
end

defmodule Phoenix.Socket.HandlerIntegrationTest do
  use ExUnit.Case, async: true
  use ConnHelper

  defmodule TestChannel do
    use Phoenix.Channel
  
    def join(socket, "topic", message) do
      {:ok, socket}
    end

    def join(socket, _no, _message) do
      {:error, socket, :unauthorized}
    end

    def event(socket, "user:active", %{user_id: user_id}) do
      socket
    end

    def event(socket, "user:idle", %{user_id: user_id}) do
      socket
    end

    def event(socket, "eventname", message) do
      reply socket, "return_event", "Echo: " <> message
      socket
    end
  end

  defmodule TestServer do
    use Phoenix.Router
    use Phoenix.Router.Socket, mount: "/ws"

    channel "channel",TestChannel

    def init(opts) do
      opts
    end
  end

  defmodule TestClient do
    @behaviour :websocket_client_handler

    def start_link do
      :websocket_client.start_link('ws://localhost:3000/ws', __MODULE__, [])
    end

    def init([], _conn_state) do
      {:ok, []}
    end

    def websocket_handle({:text, msg}, _conn_state, state) do
      IO.puts msg
      {:ok, state}
    end

    def websocket_terminate(reason, _conn_state, _state) do
      IO.puts reason
      :ok
    end
  end

  setup_all do

    capture_log fn ->
      {:ok, _pid } = Phoenix.Router.Adapter.start(TestServer, port: 3000)
    end

    {:ok, pid} = TestClient.start_link


    on_exit fn ->
      capture_log fn ->
        :ok = Phoenix.Router.Adapter.stop(TestServer, [])
        pid.stop()
      end
    end
    :ok
  end

  test "makes simple request" do
     :websocket_client.cast(TestClient, {:text, "message 1"})
  end
end

defmodule Phoenix.Socket.HandlerIntegrationTest do
  use ExUnit.Case, async: true

  defmodule DummyyChannel do
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

  defmodule Dummy do
    use Phoenix.Router
    use Phoenix.Router.Socket, mount: "/ws"

    channel "channel", .DummyChannel

    def init(opts) do
      opts
    end
  end

  ## Cowboy setup for testing
  #
  # We use hackney to perform an HTTP request against the cowboy/plug running
  # on port 8001. Plug then uses Kernel.apply/3 to dispatch based on the first
  # element of the URI's path.
  #
  # e.g. `assert {204, _, _} = request :get, "/build/foo/bar"` will perform a
  # GET http://127.0.0.1:8001/build/foo/bar and Plug will call build/1.


  setup_all do
    {:ok, _pid} = Plug.Adapters.Cowboy.http __MODULE__, [], port: 8001

    on_exit fn ->
      :ok = Plug.Adapters.Cowboy.shutdown(__MODULE__.HTTP)
    end
    :ok
  end
end

defmodule Phoenix.Integration.LongPollingClient do
  alias Poison, as: JSON

  @doc """
  Starts the WebSocket server for given ws URL. Received Socket.Message's
  are forwarded to the sender pid
  """
  def start_link() do
    :crypto.start
    :ssl.start
    :application.start(:public_key)
    :hackney.start
  end

  @doc """
  GETs the url, with the specified timeout, default is 500ms
  """
  def get(url, timeout \\ 500) do
    :hackney.request(:get, url, [], "", [{:recv_timeout, timeout}]) |> handle_resp
  end

  @doc """
  POSTs to the url, with the payload
  """
  def post(url, payload) do
    :hackney.request(:post, url, [], payload) |> handle_resp
  end

  defp handle_resp({:ok, status, _headers, client}) do
    {:ok, body} = :hackney.body(client)
    {status, body}
  end

  defp handle_resp(other) do
    other
  end

  defp json!(map), do: JSON.encode!(map) |> IO.iodata_to_binary
end


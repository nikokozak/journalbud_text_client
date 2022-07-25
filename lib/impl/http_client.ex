defmodule TextClient.Impl.HTTPClient do
  alias TextClient.Impl.HTTPClient.Request
  alias TextClient.Impl.HTTPClient.Response

  @callback do_request(Request.t) :: {:ok, Response.t} | {:error, TextClient.Error.t}

  @spec request(Request.t) :: {:ok, Response.t} | {:error, TextClient.Error.t}
  def request(request) do
    do_request(request, get_client())
  end

  @spec do_request(Request.t, atom) :: {:ok, Response.t} | {:error, TextClient.Error.t}
  defp do_request(request, client), do: request |> client.do_request()

  def get_client, do: Application.fetch_env!(:text_client, :http_client)

end

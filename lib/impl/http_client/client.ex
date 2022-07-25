defmodule TextClient.Impl.HTTPClient.Client do
  use HTTPoison.Base
  alias TextClient.Impl.Error
  alias TextClient.Impl.HTTPClient.Request
  @behaviour TextClient.Impl.HTTPClient

  def process_response_body(""), do: nil
  def process_response_body(body) do
    body
    |> Poison.decode!(keys: :atoms)
  end

  @spec do_request(Request.t) :: {:ok, %{ status: atom, body: map | nil }} | {:error, Error.t}
  def do_request(request) do
    struct(HTTPoison.Request, Map.from_struct(request))
    |> request()
    |> handle_response()
  end

  def handle_response({:error, %HTTPoison.Error{} = error}), do: {:error, Error.new(error)}
  def handle_response({:ok, %HTTPoison.Response{} = response}) do
    {:ok, %{ status: response.status_code, body: response.body }}
  end

end

defmodule TextClient.Impl.HTTPClient.Request do
  alias TextClient.Impl.HTTPClient

  @type method :: :get | :post | :delete | :patch

  @type t :: %{
    optional(:options) => map,
    optional(:body) => map | String.t,
    optional(:params) => map,
    method: method,
    headers: Keyword.t,
    url: String.t,
  }
  defstruct [:url, :method, :headers, :params, body: ""]

  @spec new_request() :: t
  def new_request, do: %__MODULE__{} |> put_auth_header |> put_accepts_header

  @spec put_header(t, Keyword.t) :: t
  def put_header(request, [{keyword, value}]) when is_atom(keyword) do
    request
    |> get_or_default!(:headers, Keyword.new())
    |> Keyword.put(keyword, value)
    |> (&Map.put(request, :headers, &1)).()
  end

  @spec put_auth_header(t) :: t
  def put_auth_header(request) do
    provider = Application.fetch_env!(:text_client, :provider)
    api_key = Application.fetch_env!(:text_client, provider) |> Keyword.fetch!(:auth_header)

    request
    |> put_header(Authorization: api_key)
  end

  @spec put_accepts_header(t) :: t
  def put_accepts_header(request) do
    request
    |> put_header(Accept: "application/json")
  end

  @spec put_endpoint(t, String.t) :: t
  def put_endpoint(request, url), do: request |> Map.put(:url, url)

  @spec put_method(t, method) :: t
  def put_method(request, method), do: request |> Map.put(:method, method)

  @spec put_body(t, map, Keyword.t | false) :: t
  def put_body(request, body), do: put_body(request, body, false)
  def put_body(request, nil, _), do: request
  def put_body(request, %{} = empty_map, _) when empty_map == %{}, do: request
  def put_body(request, body, uri_encoded: true) do
    body
    |> URI.encode_query()
    |> (&Map.put(request, :body, &1)).()
  end
  def put_body(request, body, _) when is_map(body) do
    body
    |> Poison.encode!(body)
    |> (&Map.put(request, :body, &1)).()
  end

  @spec put_params(t, map) :: t
  def put_params(request, nil), do: request
  def put_params(request, %{} = empty_map) when empty_map == %{}, do: request
  def put_params(request, params), do: request |> Map.put(:params, params)

  @spec make_request(t) :: {:ok, map} | {:error, TextClient.Error.t}
  def make_request(request), do: HTTPClient.request(request)

  defp get_or_default!(map, key, default \\ nil) do
    case Map.fetch!(map, key) do
      nil -> default
      value -> value
    end
  end

end

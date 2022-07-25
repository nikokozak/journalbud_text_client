defmodule TextClient.Impl.MessageBird.Contact do
  import TextClient.Impl.HTTPClient.Request
  alias TextClient.Impl.HTTPClient.Response
  alias TextClient.Impl.Error

  @endpoint "https://rest.messagebird.com/contacts/"

  @type t :: %{
    id: Strint.t,
    href: String.t,
    msisdn: String.t,
    firstName: String.t,
    lastName: String.t,
    customDetails: %{
      custom1: String.t,
      custom2: String.t,
      custom3: String.t,
      custom4: String.t,
    },
      groups: %{
      totalCount: integer,
      href: String.t
    },
    messages: %{
      totalCount: integer,
      href: String.t
    },
    createdDateTime: String.t,
    updatedDateTime: String.t
  }

  defstruct [
    :id,
    :href,
    :msisdn,
    :firstName,
    :lastName,
    :customDetails,
    :groups,
    :messages,
    :createdDatetime,
    :updatedDatetime
  ]

  ########################################

  @spec create(params) :: {:ok, t} | {:error, Error.t}
  when params: 
  %{ 
    optional(:firstName) => String.t, 
    optional(:lastName) => String.t,
    optional(:custom1) => String.t,
    optional(:custom2) => String.t,
    optional(:custom3) => String.t,
    optional(:custom4) => String.t,
    msisdn: String.t 
  } 
  def create(params) do
    create_request(params)
    |> make_request
    |> format_create_response
  end

  defp create_request(params) do
    new_request()
    |> put_method(:post)
    |> put_endpoint(@endpoint)
    |> put_body(params)
  end

  defp format_create_response(response), do: format_response(response, :create)

  ########################################

  @spec get(String.t) :: {:ok, t | nil} | {:error, Error.t}
  def get(contact_id) when is_binary(contact_id), do: get([id: contact_id])

  @spec get(params) :: {:ok, t | nil} | {:error, Error.t}
  when params:
  [
    name: String.t,
    msisdn: String.t,
    id: String.t
  ]
  def get([id: contact_id]) do
    new_request()
    |> put_method(:get)
    |> put_endpoint(@endpoint <> contact_id)
    |> make_request
    |> format_get_response()
  end
  def get([msisdn: msisdn]) do
    new_request()
    |> put_method(:get)
    |> put_endpoint(@endpoint)
    |> put_params(%{msisdn: msisdn})
    |> make_request
    |> format_get_response()
  end
  def get([name: name]) do
    new_request()
    |> put_method(:get)
    |> put_endpoint(@endpoint)
    |> put_params(%{name: name})
|> IO.inspect
    |> make_request
    |> format_get_response()
  end

  defp format_get_response(response), do: format_response(response, :get)

  ########################################
  
  @spec update(String.t, params) :: {:ok, t} | {:error, Error.t}
  when params:
  %{
    optional(:firstName) => String.t,
    optional(:lastName) => String.t,
    optional(:custom1) => String.t,
    optional(:custom2) => String.t,
    optional(:custom3) => String.t,
    optional(:custom4) => String.t,
  }
  def update(id, opts) do
    new_request()
    |> put_method(:patch)
    |> put_endpoint(@endpoint <> id)
    |> put_body(opts)
    |> make_request
    |> format_update_response()
  end

  defp format_update_response(response), do: format_response(response, :update)


  ########################################

  @spec delete(String.t) :: {:ok, nil} | {:error, Error.t}
  def delete(id) do
    new_request()
    |> put_method(:delete)
    |> put_endpoint(@endpoint <> id)
    |> make_request
    |> format_delete_response
  end

  defp format_delete_response(response), do: format_response(response, :delete)

  ########################################
  #   RESPONSE FORMATTERS
  ########################################

  defp format_response({:ok, %Response{ status: 200, body: %{ count: 0 } }}, :get), do: {:ok, nil}
  defp format_response({:ok, %Response{ status: 200, body: %{ count: 1, items: [contact] } }}, :get) do
    {:ok, struct(__MODULE__, contact)}
  end
  defp format_response({:ok, %Response{ status: 200, body: %{ count: _, items: contacts } }}, :get) do
    {:ok, (for contact <- contacts, do: struct(__MODULE__, contact)) }
  end
  defp format_response({:ok, %Response{ status: 200, body: %{ msisdn: _phone } = contact }}, :get) do
    {:ok, struct(__MODULE__, contact)}
  end

  defp format_response({:ok, %Response{ status: 201, body: body }}, :create) do
    {:ok, struct(__MODULE__, body)}
  end

  defp format_response({:ok, %Response{ status: 200, body: contact }}, :update) do
    {:ok, struct(__MODULE__, contact)}
  end

  defp format_response({:ok, %Response{ status: 204, body: _ }}, :delete), do: {:ok, nil}

  defp format_response({:ok, %Response{ status: unexpected_status_code, body: body }}, _method) do
    {:error, Error.new(unexpected_status_code, body) }
  end
  defp format_response({:error, %Error{}} = error, _method), do: {:error, error}


end

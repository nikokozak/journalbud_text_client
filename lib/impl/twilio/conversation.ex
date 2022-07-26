defmodule TextClient.Impl.Twilio.Conversation do
  alias TextClient.Impl.Error
  alias TextClient.Impl.HTTPClient.Response
  import TextClient.Impl.HTTPClient.Request

  @endpoint "https://conversations.twilio.com/v1/Conversations/"

  @type state :: :active | :inactive | :closed

  @type t :: %{
    sid: String.t,
    account_sid: String.t,
    chat_service_sid: String.t,
    messaging_service_sid: String.t,
    friendly_name: String.t,
    unique_name: String.t,
    attributes: map, # used for custom information
    date_created: String.t,
    date_updated: String.t,
    state: state,
    timers: map, # stores times when certain things happened to convo
    bindings: map,
    url: String.t,
    links: %{
      participants: String.t,
      messages: String.t,
      webhooks: String.t
    }
  }

  defstruct [
    :sid,
    :account_sid,
    :chat_service_sid,
    :messaging_service_sid,
    :friendly_name,
    :unique_name,
    :attributes,
    :date_created,
    :date_updated,
    :state,
    :timers,
    :bindings,
    :url,
    :links
  ]

  ########################################

  @spec create(params) :: {:ok, t} | {:error, Error.t}
  when params:
  %{
    optional(:FriendlyName) => String.t,
    optional(:UniqueName) => String.t,
    optional(:MessagingServiceSid) => String.t,
    optional(:Attributes) => map,
    optional(:State) => state,
  }
  def create(params) do
    new_request()
    |> put_method(:post)
    |> put_endpoint(conversation_endpoint())
    |> put_header(url_encoded_content_type_header())
    |> put_body(params)
    |> make_request
    |> format_create_response
  end

  defp format_create_response(response), do: format_response(response, :create)

  ########################################

  @spec get(String.t) :: {:ok, t | nil} | {:error, Error.t}
  def get(sid) do
    new_request()
    |> put_method(:get)
    |> put_endpoint(conversation_endpoint(sid))
    |> make_request()
    |> format_get_response
  end

  defp format_get_response(response), do: format_response(response, :get)

  ########################################

  @spec all(opts) :: {:ok, [t] | []} | {:error, Error.t}
  when opts:
  %{ PageSize: integer }
  def all(opts \\ %{}) do
    new_request()
    |> put_method(:get)
    |> put_endpoint(conversation_endpoint())
    |> put_params(opts)
    |> make_request()
    |> format_all_response
  end

  defp format_all_response(response), do: format_response(response, :all)

  ########################################

  @spec update(String.t, params) :: {:ok, t} | {:error, Error.t}
  when params:
  %{
    optional(:Attributes) => map,
    optional(:State) => state
  }
  def update(sid, params) do
    new_request()
    |> put_method(:post)
    |> put_endpoint(conversation_endpoint(sid))
    |> put_header(url_encoded_content_type_header())
    |> put_body(params)
    |> make_request()
    |> format_update_response
  end

  defp format_update_response(response), do: format_response(response, :update)

  ########################################

  @spec delete(String.t) :: {:ok, nil} | {:error, Error.t}
  def delete(sid) do
    new_request()
    |> put_method(:delete)
    |> put_endpoint(conversation_endpoint(sid))
    |> make_request()
    |> format_delete_response
  end

  defp format_delete_response(response), do: format_response(response, :delete)

  ########################################

  defp format_response({:ok, %Response{status: 201, body: %{ sid: _ } = convo}}, :create) do
    {:ok, struct(__MODULE__, convo)}
  end
  defp format_response({:ok, %Response{status: 200, body: %{ sid: _ } = convo}}, :get) do
    {:ok, struct(__MODULE__, convo)}
  end
  defp format_response({:ok, %Response{status: 200, body: %{ conversations: convos }}}, :all) do
    {:ok, (for convo <- convos, do: struct(__MODULE__, convo)) }
  end
  defp format_response({:ok, %Response{status: 200, body: %{ sid: _ } = convo}}, :update) do
    {:ok, struct(__MODULE__, convo)}
  end
  defp format_response({:ok, %Response{status: 204, body: _}}, :delete), do: {:ok, nil}

  defp format_response({:ok, %Response{status: unexpected_status_code, body: body}}, _method) do
    {:error, Error.new(unexpected_status_code, body)}
  end

  defp format_response({:error, %Error{}} = error, _method), do: error

  defp conversation_endpoint(), do: @endpoint
  defp conversation_endpoint(conversation_sid), do: @endpoint <> conversation_sid

  defp url_encoded_content_type_header, do: ["Content-Type": "application/x-www-form-urlencoded"]
end

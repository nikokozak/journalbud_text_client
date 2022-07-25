defmodule TextClient.Impl.Twilio.Message do
  alias TextClient.Impl.Error
  alias TextClient.Impl.HTTPClient.Response
  import TextClient.Impl.HTTPClient.Request

  @endpoint "https://conversations.twilio.com/v1/Conversations/"

  @type t :: %{
    sid: String.t,
    account_sid: String.t,
    conversation_sid: String.t,
    body: String.t,
    media: String.t,
    author: String.t,
    participant_sid: String.t,
    attributes: map,
    date_created: String.t,
    date_updated: String.t,
    index: integer,
    delivery: %{
      total: integer,
      sent: String.t,
      delivered: String.t,
      read: String.t,
      failed: String.t,
      undelivered: String.t
    },
    url: String.t,
    links: %{
      delivery_receipts: String.t
    }
  }

  defstruct [
    :sid,
    :account_sid,
    :conversation_sid,
    :body,
    :media,
    :author,
    :participant_sid,
    :attributes,
    :date_created,
    :date_updated,
    :index,
    :delivery,
    :url,
    :links
  ]

  ########################################

  @spec create(String.t, params) :: {:ok, t} | {:error, Error.t}
  when params:
  %{
    optional(:Author) => String.t,
    optional(:Body) => String.t,
    optional(:Attributes) => map
  }
  def create(conversation_sid, params) do
    new_request()
    |> put_method(:post)
    |> put_endpoint(@endpoint <> conversation_sid <> "/Messages")
    |> put_body(params)
    |> make_request
    |> format_create_response
  end

  defp format_create_response(response), do: format_response(response, :create)

  ########################################

  @spec get(String.t, String.t) :: {:ok, t | nil} | {:error, Error.t}
  def get(conversation_sid, message_sid) do
    new_request()
    |> put_method(:get)
    |> put_endpoint(@endpoint <> conversation_sid <> "/Messages/" <> message_sid)
    |> make_request()
    |> format_get_response
  end

  defp format_get_response(response), do: format_response(response, :get)

  ########################################

  @spec all(String.t) :: {:ok, [t] | nil} | {:error, Error.t}
  def all(conversation_sid) do
    new_request()
    |> put_method(:get)
    |> put_endpoint(@endpoint <> conversation_sid <> "/Messages")
    |> make_request()
    |> format_all_response
  end

  defp format_all_response(response), do: format_response(response, :all)

  ########################################

  @spec update(String.t, String.t, params) :: {:ok, t} | {:error, Error.t}
  when params:
  %{
    optional(:Author) => String.t,
    optional(:Body) => String.t,
    optional(:Attributes) => map,
  }
  def update(conversation_sid, message_sid, params) do
    new_request()
    |> put_method(:post)
    |> put_endpoint(@endpoint <> conversation_sid <> "/Messages/" <> message_sid)
    |> put_body(params)
    |> make_request()
    |> format_update_response
  end

  defp format_update_response(response), do: format_response(response, :update)

  ########################################

  @spec delete(String.t, String.t) :: {:ok, nil} | {:error, Error.t}
  def delete(conversation_sid, message_sid) do
    new_request()
    |> put_method(:delete)
    |> put_endpoint(@endpoint <> conversation_sid <> "/Messages/" <> message_sid)
    |> make_request()
    |> format_delete_response
  end

  defp format_delete_response(response), do: format_response(response, :delete)

  ########################################

  defp format_response({:ok, %Response{status: 201, body: %{ sid: _ } = message}}, :create) do
    {:ok, struct(__MODULE__, message)}
  end
  defp format_response({:ok, %Response{status: 200, body: %{ sid: _ } = message}}, :get) do
    {:ok, struct(__MODULE__, message)}
  end
  defp format_response({:ok, %Response{status: 200, body: %{ messages: messages }}}, :all) do
    {:ok, (for message <- messages, do: struct(__MODULE__, message)) }
  end
  defp format_response({:ok, %Response{status: 200, body: %{ sid: _ } = message}}, :update) do
    {:ok, struct(__MODULE__, message)}
  end
  defp format_response({:ok, %Response{status: 204, body: _}}, :delete), do: {:ok, nil}

  defp format_response({:ok, %Response{status: unexpected_status_code, body: body}}, _method) do
    {:error, Error.new(unexpected_status_code, body)}
  end

  defp format_response({:error, %Error{}} = error, _method), do: error

end

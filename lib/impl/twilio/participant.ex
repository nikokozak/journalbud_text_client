defmodule TextClient.Impl.Twilio.Participant do
  alias TextClient.Impl.Error
  alias TextClient.Impl.HTTPClient.Response
  import TextClient.Impl.HTTPClient.Request

  @endpoint "https://conversations.twilio.com/v1/Conversations/"

  @type t :: %{
    sid: String.t,
    account_sid: String.t,
    conversation_sid: String.t,
    identity: String.t,
    attributes: map,
    messaging_binding: %{
      type: String.t,
      address: String.t,
      proxy_address: String.t
    },
    role_sid: String.t,
    date_created: String.t,
    date_updated: String.t,
    url: String.t,
    last_read_message_index: String.t,
    last_read_timestamp: String.t
  }

  defstruct [
    :sid,
    :account_sid,
    :conversation_sid,
    :identity,
    :attributes,
    :messaging_binding,
    :role_sid,
    :date_created,
    :date_updated,
    :url,
    :last_read_message_index,
    :last_read_timestamp
  ]

  ########################################

  @spec create(String.t, params) :: {:ok, t} | {:error, Error.t}
  when params:
  %{
    optional(:Identity) => String.t,
    optional(:"MessageBinding.Address") => String.t, # MUST BE IN INTL FORMAT
    optional(:"MessageBinding.ProxyAddress") => String.t,
    optional(:Attributes) => map
  }
  def create(conversation_sid, params) do
    new_request()
    |> put_method(:post)
    |> put_endpoint(participants_endpoint(conversation_sid))
    |> put_header(url_encoded_content_type_header())
    |> put_body(put_default_number(params))
    |> IO.inspect
    |> make_request
    |> format_create_response
  end

  defp put_default_number(%{ "MessagingBinding.ProxyAddress": _ } = params), do: params
  defp put_default_number(params), do: Map.put(params, "MessagingBinding.ProxyAddress", twilio_sms_number())

  defp twilio_sms_number(), do: Keyword.fetch!(Application.fetch_env!(:text_client, :twilio), :sms_number)

  defp format_create_response(response), do: format_response(response, :create)

  ########################################

  @spec get(String.t, String.t) :: {:ok, t | nil} | {:error, Error.t}
  def get(conversation_sid, participant_sid) do
    new_request()
    |> put_method(:get)
    |> put_endpoint(participants_endpoint(conversation_sid, participant_sid))
    |> make_request()
    |> format_get_response
  end

  defp format_get_response(response), do: format_response(response, :get)

  ########################################

  @spec all(String.t) :: {:ok, [t] | nil} | {:error, Error.t}
  def all(conversation_sid) do
    new_request()
    |> put_method(:get)
    |> put_endpoint(participants_endpoint(conversation_sid))
    |> make_request()
    |> format_all_response
  end

  defp format_all_response(response), do: format_response(response, :all)

  ########################################

  @spec update(String.t, String.t, params) :: {:ok, t} | {:error, Error.t}
  when params:
  %{
    optional(:Identity) => String.t,
    optional(:Attributes) => map,
    optional(:Address) => String.t,
    optional(:ProxyAddress) => String.t
  }
  def update(conversation_sid, participant_sid, params) do
    new_request()
    |> put_method(:post)
    |> put_endpoint(participants_endpoint(conversation_sid, participant_sid))
    |> put_header(url_encoded_content_type_header())
    |> put_body(params)
    |> make_request()
    |> format_update_response
  end

  defp format_update_response(response), do: format_response(response, :update)

  ########################################

  @spec delete(String.t, String.t) :: {:ok, nil} | {:error, Error.t}
  def delete(conversation_sid, participant_sid) do
    new_request()
    |> put_method(:delete)
    |> put_endpoint(participants_endpoint(conversation_sid, participant_sid))
    |> make_request()
    |> format_delete_response
  end

  defp format_delete_response(response), do: format_response(response, :delete)

  ########################################

  defp format_response({:ok, %Response{status: 201, body: %{ sid: _ } = participant}}, :create) do
    {:ok, struct(__MODULE__, participant)}
  end
  defp format_response({:ok, %Response{status: 200, body: %{ sid: _ } = participant}}, :get) do
    {:ok, struct(__MODULE__, participant)}
  end
  defp format_response({:ok, %Response{status: 200, body: %{ participants: participants }}}, :all) do
    {:ok, (for participant <- participants, do: struct(__MODULE__, participant)) }
  end
  defp format_response({:ok, %Response{status: 200, body: %{ sid: _ } = participant}}, :update) do
    {:ok, struct(__MODULE__, participant)}
  end
  defp format_response({:ok, %Response{status: 204, body: _}}, :delete), do: {:ok, nil}

  defp format_response({:ok, %Response{status: unexpected_status_code, body: body}}, _method) do
    {:error, Error.new(unexpected_status_code, body)}
  end

  defp format_response({:error, %Error{}} = error, _method), do: error

  defp participants_endpoint(conversation_sid), do: @endpoint <> conversation_sid <> "/Participants/"
  defp participants_endpoint(conversation_sid, participant_sid) do
    @endpoint <> conversation_sid <> "/Participants/" <> participant_sid
  end

  defp url_encoded_content_type_header, do: ["Content-Type": "application/x-www-form-urlencoded"]

end

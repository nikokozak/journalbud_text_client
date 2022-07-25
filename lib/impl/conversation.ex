defmodule TextClient.Impl.Conversation do
  import TextClient.Impl.HTTPClient.Request

  @endpoint "https://conversations.messagebird.com/v1/conversations/"

  @type type :: :text | :image | :video | :audio | :file | :location | :event | :rich
  @type status :: :active | :archived

  @type t :: %{
    id: String.t,
    contactId: String.t,
    status: String.t,
    createdDatetime: String.t,
    updatedDatetime: String.t,
    lastReceivedDatetime: String.t,
    lastUsedChannelId: String.t,
    lastUsedPlatformId: String.t,
    messages: %{
      totalCount: integer,
      href: String.t,
      lastMessageId: String.t
    },
    contact: %{
      id: String.t,
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
      createdDatetime: String.t,
      updatedDatetime: String.t
    },
    channels: list(%{
      id: String.t,
      name: String.t,
      platformId: String.t,
      status: String.t,
      createdDatetime: String.t,
      updatedDatetime: String.t
    }),
    }

  defstruct [
    :id,
    :contactId,
    :status,
    :createdDatetime,
    :updatedDatetime,
    :lastReceivedDatetime,
    :lastUsedChannelId,
    :lastUsedPlatformId,
    :messages,
    :contact,
    :channels
  ]

  ########################################

  @spec create(params) :: {:ok, t} | {:error, TextClient.Error.t}
  when params:
  %{
    type: type,
    content: %{
      text: String.t # this key should be the same value as the "type" specified above
    },
    to: String.t, # can either be the phone num of the receiver, or the ContactID
    channelId: String.t, # the MessageBird channel through which the message is sent
  }
  def create(params) do
    new_request()
    |> put_method(:post)
    |> put_endpoint(@endpoint <> "start")
    |> put_body(params)
    |> make_request
  end

  ########################################

  @spec all(opts) :: {:ok, list(t) | list()} | {:error, TextClient.Error.t}
  when opts: [
    limit: integer,
    offset: integer,
    status: status
  ]
  def all(opts \\ []) do
    new_request()
    |> put_method(:get)
    |> put_endpoint(@endpoint)
    |> put_get_params(opts)
    |> make_request
  end

  ########################################

  @spec get(String.t) :: {:ok, t | nil} | {:error, TextClient.Error.t}
  def get(conversation_id), do: get([id: conversation_id])

  @spec get(params) :: {:ok, t | nil} | {:error, TextClient.Error.t}
  when params: [
    contact_id: String.t,
    id: String.t,
    limit: integer,
    offset: integer,
    status: status
  ]
  def get([id: conversation_id] = opts) do
    new_request()
    |> put_method(:get)
    |> put_endpoint(@endpoint <> conversation_id)
    |> put_get_params(opts)
    |> make_request
  end
  def get([contact_id: contact_id] = opts) do
    new_request()
    |> put_method(:get)
    |> put_endpoint(@endpoint <> "/contact/#{contact_id}")
    |> put_get_params(opts)
    |> make_request
  end

  defp put_get_params(request, params, exclude \\ [:id, :contact_id]) do
    formatted_params = filter_params(params, exclude)

    request
    |> put_params(formatted_params)
  end

  defp filter_params(params, to_remove) do
    params
    |> remove_params(to_remove)
    |> Enum.into(%{})
  end

  defp remove_params(params, keys), do: Enum.reduce(keys, params, &remove_param(&2, &1))
  defp remove_param(params, key), do: Keyword.delete(params, key)

  ########################################

  @spec update(String.t, status) :: {:ok, t} | {:error, TextClient.Error.t}
  def update(conversation_id, conversation_status) do
    new_request()
    |> put_method(:patch)
    |> put_endpoint(@endpoint <> conversation_id)
    |> put_body(%{ status: conversation_status })
    |> make_request
  end

  ########################################

  @spec delete(String.t) :: {:ok, nil} | {:error, TextClient.Error.t}
  def delete(conversation_id) do
    new_request()
    |> put_method(:delete)
    |> put_endpoint(@endpoint <> conversation_id)
    |> make_request
  end
end

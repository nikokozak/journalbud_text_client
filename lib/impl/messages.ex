defmodule TextClient.Impl.MessageBird.Messages do
    # https://developers.messagebird.com/api/conversations/#start-conversation

  @type content_type :: :text | :image | :video | :audio
  @type channel_type :: :sms | :whatsapp

  def expected_fields do
    ~w(id status)
  end

  def send(to_id, channel_type, content, content_type \\ :text) do
    send_params = %{
      to: to_id,
      from: get_channel_id_from_type(channel_type),
      type: content_type,
      content: %{
        content_type => content
      }
    }

   # __MODULE__.post("send", send_params)
  end

  @spec get_channel_id_from_type(channel_type) :: String.t
  defp get_channel_id_from_type(channel_type) do
    Application.fetch_env!(:text_client, channel_config_key(channel_type))
  end

  defp channel_config_key(:sms), do: :sms_channel

  def process_request_url(url), do: "https://conversations.messagebird.com/v1/" <> url

end

defmodule TextClient.Impl.MessageBird.Conversations do
    # https://developers.messagebird.com/api/conversations/#start-conversation
  use HTTPoison.Base

  def expected_fields do
    ~w(
      id contactId contact msisdn
      firstName lastName customDetails createdDatetime
      updatedDatetime channels status lasReceivedDatetime
      lastUsedChannelId lastUsedPlatformId messages
    )
  end

  def process_request_url(url), do: "https://conversations.messagebird.com/v1/" <> url

end

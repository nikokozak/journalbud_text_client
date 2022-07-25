import Config

config :text_client, 
  messagebird_api_key: if Mix.env() == :test, do: System.fetch_env!("MESSAGEBIRD_LIVE_KEY"), else: System.fetch_env!("MESSAGEBIRD_TEST_KEY")

config :text_client, 
  sms_channel: "a9561261890345b18ca5a16be4e07e43"

config :text_client,
http_client: if Mix.env() == :test, do: TextClient.Impl.HTTPClient.MockClient, else: TextClient.Impl.HTTPClient.Client

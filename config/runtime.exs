import Config

config :text_client, 
  messagebird_api_key: if Mix.env() == :prod, do: System.fetch_env!("MESSAGEBIRD_LIVE_KEY"), else: System.fetch_env!("MESSAGEBIRD_TEST_KEY")

config :text_client, 
  sms_channel: System.fetch_env!("MESSAGEBIRD_SMS_CHANNEL")

config :text_client,
http_client: if Mix.env() == :test, do: TextClient.Impl.HTTPClient.MockClient, else: TextClient.Impl.HTTPClient.Client

import Config
alias TextClient.Impl.HTTPClient.{Client, MockClient}
alias TextClient.Impl.Twilio
import TextClient.Impl.Utils

config :text_client, provider: :twilio

config :text_client,
  messagebird_api_key: if_env_prod env!("MESSAGEBIRD_LIVE_KEY"), env!("MESSAGEBIRD_TEST_KEY")

config :text_client, 
  sms_channel: env!("MESSAGEBIRD_SMS_CHANNEL")

config :text_client,
    http_client: if_env_test MockClient, Client

config :text_client, :twilio,
  auth_header: "Basic #{ Base.encode64("#{System.fetch_env!("TWILIO_ACCOUNT_SID")}:#{System.fetch_env!("TWILIO_AUTH_TOKEN")}") }"

config :text_client, :message_bird,
  auth_header: "AccessKey #{if_env_prod env!("MESSAGEBIRD_LIVE_KEY"), env!("MESSAGEBIRD_TEST_KEY")}"

config :text_client, :twilio,
  sms_number: "+18433505454"

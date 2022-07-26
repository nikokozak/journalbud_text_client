defmodule TextClient.Impl.Twilio do
  alias TextClient.Impl.Error
  alias TextClient.Impl.Twilio.{Conversation, Participant, Message}

  @moduledoc """
  Twilio API.

  Allows access to Twilio via functions that send out REST requests.

  Twilio account details should be specified in the local environment as ENV variables, namely:

  $TWILIO_ACCOUNT_SID
  $TWILIO_AUTH_TOKEN

  As well, the default SMS twilio number is specified in the runtime config file under :text_client/:twilio/:sms_number

  Creating a new contact requires first creating a Conversation, after which a Participant can be created
  (this participant can have attributes, but mainly just exists to allow for specification of a phone-number endpoint.)

  Once a Conversation is created, Messages can be sent through it. In other words, Messages are not sent "to" someone,
  rather they are "created" in a Conversation, which automatically dispatches the contents of the message to all Participants.

  Errors are wrapped in a custom Error struct, which maps error codes to messages via helper functions defined in the Types module.
  """

  defdelegate create_conversation(params), to: Conversation, as: :create
  defdelegate get_conversation(convo_sid), to: Conversation, as: :get
  defdelegate get_all_conversations(), to: Conversation, as: :all
  defdelegate update_conversation(convo_sid, params), to: Conversation, as: :update
  defdelegate delete_conversation(convo_sid), to: Conversation, as: :delete

  defdelegate create_participant(convo_sid, params), to: Participant, as: :create
  defdelegate get_participant(convo_sid, participant_sid), to: Participant, as: :get
  defdelegate get_all_participants(convo_sid), to: Participant, as: :all
  defdelegate update_participant(convo_sid, participant_sid, params), to: Participant, as: :update
  defdelegate delete_participant(convo_sid, participant_sid), to: Participant, as: :delete

  defdelegate create_message(convo_sid, params), to: Message, as: :create
  defdelegate get_message(convo_sid, message_sid), to: Message, as: :get
  defdelegate get_all_messages(convo_sid), to: Message, as: :all
  defdelegate update_message(convos_sid, message_sid, params), to: Message, as: :update
  defdelegate delete_message(convo_sid, message_sid), to: Message, as: :delete

  @spec send_text_message(String.t, String.t) :: {:ok, Message.t} | {:error, Error.t}
  def send_text_message(convo_sid, text) do
    create_message(convo_sid, %{ Body: text })
  end
end

defmodule ConversationTests do
    use ExUnit.Case
    alias TextClient.Impl.Conversation

    test "create/1 correctly creates a contact" do
      {:ok, %Conversation{} = _convo} = Conversation.create(%{
            type: "text",
            content: %{ text: "Hello there!" },
            to: "6468327483",
            channelId: "a_messengerbird_channel_id"
                                                            })
    end

    describe "get/1 correctly retrieves a conversation" do

      test "get/1 with id" do
        {:ok, %Conversation{} = _conversation} = Conversation.get("a_messengerbird_id")
      end

      test "get/1 with name" do
        {:ok, %Conversation{} = _conversation} = Conversation.get(contact_id: "a_messengerbird_contact_id")
      end

      test "get/1 with id option" do
        {:ok, %Conversation{} = _conversation} = Conversation.get(id: "a_messengerbird_id")
      end

    end

    test "update/2 correctly updates a conversation" do

        {:ok, %Conversation{} = _conversation} = Conversation.update("a_messengerbird_id", :archived)

    end

    test "delete/1 correctly deletes a contact" do

      {:ok, nil} = Conversation.delete("a_messengerbird_id")

    end

end

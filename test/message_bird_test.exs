defmodule MessageBirdTest do
  use ExUnit.Case
  alias TextClient.Impl.MessageBird

  test "gets a contact by number" do
    {:ok, _id} = MessageBird.get_contact_by_number("16468345894")
    {:error, {:not_found, _details}} = MessageBird.get_contact_by_number("12345879838")
    {:error, {:not_found, _details}} = MessageBird.get_contact_by_number("123")
    {:error, {:not_found, _details}} = MessageBird.get_contact_by_number("yankeedoodle")
  end

  test "deletes a contact by number" do
    MessageBird.delete_contact_by_number("16327778989")
    {:ok, id} = MessageBird.create_contact("16327778989")
    {:ok, _deleted} = MessageBird.delete_contact_by_number("16327778989")
    {:error, {:not_found, _}} = MessageBird.delete_contact_by_number("16327778989")
  end

  test "creates a contact" do
    if {:ok, _id} = MessageBird.get_contact_by_number("16468345894") do
      MessageBird.delete_contact_by_number("16468345894")
      assert {:ok, _id} = MessageBird.create_contact("+16468345894")
    end
    {:error, {:contact_exists, _}} = MessageBird.create_contact("+16468345894", %{ firstName: "Nikolai", lastName: "Kozak" })
  end

  test "creates a contact and sends a message" do
    case MessageBird.get_contact_by_number("16468753694") do
      {:ok, id} ->
        response = MessageBird.send_sms_message("+16468753694", "Hey, this is my first message from MessageBird")
        IO.inspect(response)
      {:error, {:not_found, _}} ->
        {:ok, id} = MessageBird.create_contact("16468753694")
        response = MessageBird.send_sms_message("16468753694", "Hey, this is my first message from MessageBird")
        IO.inspect(response)
        assert response = {:ok, %HTTPoison.Response{}}
    end
  end
end

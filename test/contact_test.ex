defmodule ContactTest do
    use ExUnit.Case
    alias TextClient.Impl.Contact

    test "create/1 correctly creates a contact" do
      {:ok, %Contact{} = _contact} = Contact.create(%{
            msisdn: "16468345474",
            firstName: "Nikolai",
            lastName: "Kozak",
            email: "nikokozak@gmail.com" })
    end

    describe "get/1 correctly retrieves a contact" do

      test "get/1 with id" do
        {:ok, %Contact{} = _contact} = Contact.get("a_messengerbird_id")
      end

      test "get/1 with name" do
        {:ok, %Contact{} = _contact} = Contact.get(name: "Nikolai")
      end

      test "get/1 with msisdn" do
        {:ok, %Contact{} = _contact} = Contact.get(msisdn: "6468379825")
      end

      test "get/1 with id option" do
        {:ok, %Contact{} = _contact} = Contact.get(id: "a_messengerbird_id")
      end

    end

    test "update/2 correctly updates a contact" do

        {:ok, %Contact{} = _contact} = Contact.update("a_messengerbird_id", %{ msisdn: "64653218181" })

    end

    test "delete/1 correctly deletes a contact" do

      {:ok, nil} = Contact.delete("a_messengerbird_id")

    end

end

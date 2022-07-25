defmodule TextClient.Impl.MessageBird do

  def create_contact(number, opts \\ %{}) do
    __MODULE__.Contacts.create(number, opts)
  end

  @doc """
  Takes a number in intl. format WITHOUT the leading "+"
  """
  def get_contact_by_number(number) when is_binary(number) do
    __MODULE__.Contacts.get_by_number(number)
  end

  def delete_contact_by_number(number) do
    __MODULE__.Contacts.delete_by_number(number)
  end

  def send_sms_message(to_id, text) do
    __MODULE__.Messages.send(to_id, :sms, text)
  end
end

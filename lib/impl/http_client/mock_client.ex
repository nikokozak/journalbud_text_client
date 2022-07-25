defmodule TextClient.Impl.HTTPClient.MockClient do
  @behaviour TextClient.Impl.HTTPClient

  @contact_endpoint "https://rest.messagebird.com/contacts/"

  def do_request(%{ url: @contact_endpoint, method: :post }) do
    {:ok, %{
        status: 201,
        body: response_body(@contact_endpoint, :post, 201) |> decode_body() }}
  end

  def do_request(%{ url: @contact_endpoint <> _params, method: :get }) do
    {:ok, %{
        status: 200,
        body: response_body(@contact_endpoint, :get, 200) |> decode_body() }}
  end

  def do_request(%{ url: @contact_endpoint <> _id, method: :patch }) do
    {:ok, %{
        status: 200,
        body: response_body(@contact_endpoint, :patch, 200) |> decode_body() }}
  end

  def do_request(%{ url: @contact_endpoint <> _id, method: :delete }) do
    {:ok, %{
        status: 204,
        body: response_body(@contact_endpoint, :delete, 204) |> decode_body() }}
  end

  defp response_body("https://rest.messagebird.com/contacts/", :patch, 200), do: response_body("https://rest.messagebird.com/contacts/", :post, 201)
  defp response_body("https://rest.messagebird.com/contacts/", :get, 200), do: response_body("https://rest.messagebird.com/contacts/", :post, 201)
  defp response_body("https://rest.messagebird.com/contacts/", :post, 201) do
    ~S({
      "id": "12d899254f2642a09b96fa164ece03f2",
      "href": "https://rest.messagebird.com/contacts/12d899254f2642a09b96fa164ece03f2",
      "msisdn": 16468753694,
      "firstName": "Nikolai",
      "lastName": "Kozak",
      "customDetails": {
        "custom1": "nikokozak@gmail.com",
        "custom2": null,
        "custom3": null,
        "custom4": null
      },
      "groups": {
        "totalCount": 0,
        "href": "https://rest.messagebird.com/contacts/12d899254f2642a09b96fa164ece03f2/groups"
      },
      "messages": {
        "totalCount": 0,
        "href": "https://rest.messagebird.com/contacts/12d899254f2642a09b96fa164ece03f2/messages"
      },
      "createdDatetime": "2022-07-22T21:35:59+00:00",
      "updatedDatetime": "2022-07-22T21:35:59+00:00"
    })
  end
  defp response_body("https://rest.messagebird.com/contacts/", :delete, 204), do: nil

  defp decode_body(nil), do: nil
  defp decode_body(body), do: Poison.decode!(body, keys: :atoms)

end

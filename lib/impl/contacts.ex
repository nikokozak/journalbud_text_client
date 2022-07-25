defmodule TextClient.Impl.MessageBird.Contacts do

  def expected_fields do
    ~w(id href msisdn firstName lastName customDetails
    groups messages createdDatetime updatedDatetime
    errors offset limit count totalCount links items)
  end
  
  ################################################## 

  def create(number, opts) do
    firstName = Map.get(opts, :firstName)
    lastName = Map.get(opts, :lastName)

    __MODULE__.post("", %{ msisdn: number, firstName: firstName, lastName: lastName })
    |> format_creation_response
  end

  defp format_creation_response({:ok, %HTTPoison.Response{body: %{errors: errors}}}) do
    first_error = List.first(errors)
    {:error, {error_code(first_error["code"]), first_error}}
  end
  defp format_creation_response({:ok, %HTTPoison.Response{status_code: code, body: body}}) when code >= 200 and code <= 300, do: {:ok, body.id}

  ################################################## 

  def get_by_number(number) do
      "?msisdn=#{number}"
      |> __MODULE__.get()
      |> format_get_response
  end

  defp format_get_response({:ok, %HTTPoison.Response{body: %{count: 0}}}) do
    {:error, {:not_found, nil}}
  end
  defp format_get_response({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    body.items
    |> List.first
#    |> atomify_struct
    |> (&{:ok, &1.id}).()
  end

  ################################################## 

  def delete_by_number(number) do
    get_by_number(number)
    |> delete_found_contact
  end

  defp delete_found_contact({:ok, id}) do
    __MODULE__.delete(id)
    |> format_delete_response
  end
  defp delete_found_contact({:error, {:not_found, _}} = res), do: res

  def format_delete_response({:ok, %HTTPoison.Response{status_code: 204}}), do: {:ok, nil}
  def format_delete_response({:ok, %HTTPoison.Response{status_code: 404}}), do: {:error, {:not_found, nil}}

  ################################################## 

  defp error_code(10), do: :contact_exists

  def process_request_url(url), do: "https://rest.messagebird.com/contacts/" <> url
end

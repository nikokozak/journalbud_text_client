defmodule TextClient.Impl.MessageBird.Response do
  @valid_response_codes [200, 201, 202, 204, 401, 404, 405, 422]
  @valid_sucess_codes [200, 201, 202, 204]
  @valid_error_codes [401, 404, 405, 422]

  def process({:ok, %HTTPoison.Response{status_code: status_code, body: body}}, module) when status_code in @valid_response_codes do
    process_valid(body, status_code, module)
  end
  def process({:error, %HTTPoison.Error{} = error}, _) do
    raise error
  end

  defp process_valid(body, code, _module) when code in @valid_sucess_codes do
    {:ok, body}
  end
  defp process_valid(body, code, module) when code in @valid_error_codes do
    {:error, {descriptive_error(code, module), body}}
  end

  defp descriptive_error(status_code, module) do
  end

end

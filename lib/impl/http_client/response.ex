defmodule TextClient.Impl.HTTPClient.Response do
  alias TextClient.Types

  @type method :: :get | :post | :delete | :patch

  @type t :: %{
    status: Types.http_code(),
    body: map | nil
  }

  defstruct [:status, :body]

end

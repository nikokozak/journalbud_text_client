defmodule HTTPClientTest do
  alias TextClient.Impl.HTTPClient
  use ExUnit.Case

  test "get_client/0 returns appropriate Mock Client" do
    assert HTTPClient.get_client() == HTTPClient.MockClient
  end

end

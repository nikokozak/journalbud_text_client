defmodule TextClient.Impl.Error do
  alias TextClient.Types

  @type t :: %{
    source: :api | :network | :internal, #Network is ONLY for HTTPoison Errors
    descriptor: atom,
    message: Strint.t,
    extra: map | nil
  }
  defstruct [:source, :descriptor, :message, :extra]

  @spec new() :: t
  def new(), do: new(%{})

  @spec new(integer) :: t
  def new(code) when is_integer(code), do: new(code, nil)

  @spec new(map) :: t
  def new(extra) when is_map(extra) do
    %__MODULE__{source: :internal, descriptor: nil, message: "An internal error occured.", extra: extra}
  end

  @spec new(HTTPoison.Error.t) :: t
  def new(%HTTPoison.Error{} = error) do
    %__MODULE__{
      source: :network,
      descriptor: :network_error,
      message: error.reason,
      extra: error
    }
  end

  @spec new(integer, map) :: t
  def new(code, extra) when is_integer(code) do
    %__MODULE__{
      source: :api,
      descriptor: Types.code_to_descriptor(code),
      message: Types.code_to_message(code),
      extra: extra
    }
  end

end

defmodule TextClient.Impl.Utils do

  def phone_regexp(), do: ~r//
  def is_us_phone(phone), do: Regex.match?(us_regexp(), phone)
  def is_chile_phone(phone), do: Regex.match?(chile_regexp(), phone)


  defp us_regexp(), do: ~r/^(\+[1])?\d{10}$/
  defp chile_regexp(), do: ~r/^(\+[5][6])?\d{9}$/
  defp us_e164_regexp(), do: ~r/\+(?<country>\d{1,3})[( -]*(?<area>\d{3})[) -]*(?<exchange>\d{3})[- ]*(?<subscriber>\d{4})/
  defp chile_e164_regexp(), do: ~r/\+(?<country>\d{2})[( -]*(?<type>\d{1})[) -]*(?<area>\d{1})[- ]*(?<subscriber>\d{7})/

  def env!(var), do: System.fetch_env!(var)

  def if_env_prod(choice, else_choice), do: env_choice(choice, else_choice, :prod)
  def if_env_test(choice, else_choice), do: env_choice(choice, else_choice, :test)

  defp env_choice(choice, else_choice, env) do
    if Mix.env() == env, do: choice, else: else_choice
  end

end

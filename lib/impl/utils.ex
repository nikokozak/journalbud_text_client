defmodule TextClient.Impl.Utils do

  def phone_regexp(), do: ""


  def env!(var), do: System.fetch_env!(var)

  def if_env_prod(choice, else_choice), do: env_choice(choice, else_choice, :prod)
  def if_env_test(choice, else_choice), do: env_choice(choice, else_choice, :test)

  defp env_choice(choice, else_choice, env) do
    if Mix.env() == env, do: choice, else: else_choice
  end

end

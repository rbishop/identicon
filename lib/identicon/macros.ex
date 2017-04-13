defmodule Identicon.Macros do

  # Creates bang case statement
  defmacro bang(result) do
    quote do
      case unquote(result) do
        {:ok, value} -> value
        {:error, error} when is_bitstring(error) -> raise error
        {:error, error} -> raise inspect error
        error -> raise inspect error
      end
    end
  end

end

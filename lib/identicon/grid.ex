defmodule Identicon.Grid do
  require Integer

  def mirror_row(row) do
    len = Enum.count row
    reversed = Enum.reverse(row)

    case Integer.is_even(len) do
      true ->
        List.flatten [row | reversed]
      false ->
        List.flatten [row | Enum.drop(reversed, 1)]
    end
  end
end

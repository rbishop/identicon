defmodule Identicon.Renderers.GitHubLike.Grid do
  require Integer

  @moduledoc """
    This module is used for taking a list of binary encoded
    hexadecimal and turning it into a 5x5 grid. Mirroring of
    each row is applied to create symmetry.
  """
  def from_hex(list) do
    list
    |> Enum.chunk(3)
    |> Enum.flat_map(&mirror_row/1)
    |> Enum.with_index
  end

  def mirror_row(row) do
    len = Enum.count row
    reversed = Enum.reverse(row)

    case Integer.is_even(len) do
      true ->
        List.flatten [row | reversed]
      false ->
        List.flatten [row | tl(reversed)]
    end
  end

  def remove_odd_bytes(grid) do
    Enum.filter grid, fn({code, _index}) ->
      rem(code, 2) == 0
    end
  end
end

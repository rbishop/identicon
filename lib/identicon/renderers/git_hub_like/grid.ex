defmodule Identicon.Renderers.GitHubLike.Grid do
  @moduledoc """
    This module is used for taking a list of binary encoded
    hexadecimal and turning it into a size x size grid. Mirroring of
    each row is applied to create symmetry.
  """

  require Integer
  require Logger

  def from_hex(list, size) do
    # column_count is before mirroring occurs.
    column_count = round(size/2)
    
    list
    |> adjust_list_to_fit_size(size)
    |> Enum.chunk(column_count)
    |> Enum.flat_map(&(mirror_row(&1, size)))
    |> Enum.with_index
  end

  @doc """
  We're going to either truncate or grow the given list to match 
  the desired `size`.
  
  E.g. 
  size 5:
    columns = 5/2 rounded (up) = 3 (because we mirror)
    rows = 5
    overall list size = 3 columns * 5 rows = 15
  
  size 10:
    columns = 10/2 rounded = 5
    rows = 10
    overall list size = 5 columns * 10 rows = 50
  """
  def adjust_list_to_fit_size(list, size) do
    column_count = round(size/2)
    row_count = size
    needed_size = column_count * row_count
    len = length(list)
    cond do
      # Already the right size
      len == needed_size -> list
      
      # List is more than we need, so truncate
      len > needed_size -> 
        
        Enum.take(list, needed_size)
      
      # List is not enough, so "grow" the list
      # I'm choosing to add bytes from the hash of the list itself.
      true -> 
        list_as_string = 
          list 
          |> Enum.map(&Integer.to_string/1) 
          |> Enum.reduce(fn (item, agg) -> agg <> item end)
        # hash the stringified list (same in Renderer, so not DRY)
        list_hash_as_list = 
          :crypto.hash(:md5, list_as_string) |> :binary.bin_to_list

        # append the list and call recursively until the list is 
        # large enough
        adjust_list_to_fit_size(list ++ list_hash_as_list, size)
    end
  end

  def mirror_row(row, size) do
    len = Enum.count row
    reversed = Enum.reverse(row)

    cond do
      Integer.is_even(len) && Integer.is_even(size) -> row ++ reversed
      Integer.is_even(len) && Integer.is_odd(size) ->  row ++ tl(reversed)
      Integer.is_odd(len) && Integer.is_even(size) ->  row ++ reversed
      Integer.is_odd(len) && Integer.is_odd(size) ->   row ++ tl(reversed)
    end
  end

  def remove_odd_bytes(grid) do
    Enum.filter grid, fn({code, _index}) ->
      rem(code, 2) == 0
    end
  end
end

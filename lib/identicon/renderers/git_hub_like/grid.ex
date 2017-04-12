defmodule Identicon.Renderers.GitHubLike.Grid do
  @moduledoc """
    This module is used for taking a list of binary encoded
    hexadecimal and turning it into a 5x5 grid. Mirroring of
    each row is applied to create symmetry.
  """

  require Integer
  require Logger

  def from_hex(list, size) do
    Logger.debug("list: #{inspect list}")
    # columns = round(size/2)
    # Need to count columns, then chunk into that size
    # I need to check in tho...leaving off here.
    result = 
      list
      |> adjust_list_size(size)
      |> Enum.chunk(3)
      |> Enum.flat_map(&mirror_row/1)
      |> Enum.with_index
    IO.puts "result: #{inspect result}"
    result
  end

  @doc """
  We're going to either truncate or extrude the given list to match 
  the desired `size`.
  
  So, if it's size 5, e.g.:
    columns = 5/2 rounded up = 3 (because we mirror)
    rows = 5
    overall list size = 15
  """
  def adjust_list_to_fit_size(list, size) do
    columns = round(size/2)
    rows = size
    needed_size = columns * rows
    len = length(list)
    cond do
      # Already the right size
      len == needed_size -> list
      
      # List is more than we need, so truncate
      len > needed_size -> Enum.take(list, needed_size)
      
      # List is not enough, so "grow" the list
      # Since this doesn't need to be cryptographically secure or 
      # anything, I'm just going to repeat the list until it's big 
      # enough
      true -> 
        list_as_string = 
          list 
          |> Enum.map(&Integer.to_string/1) 
          |> Enum.reduce(fn (item, agg) -> agg <> item end)
        # hash the list
        list_hash = :crypto.hash(:md5, list_as_string)
        
        # Add the hash numbers 
    end
  end

  def mirror_row(row) do
    len = Enum.count row
    reversed = Enum.reverse(row)
    
    IO.puts "row len: #{len}"

    case Integer.is_even(len) do
      true ->
        List.flatten [row | reversed]
      false ->
        List.flatten [row | tl(reversed)]
    end
  end

  # def remove_odd_bytes(grid) do
  #   Enum.filter grid, fn({code, _index}) ->
  #     rem(code, 2) == 0
  #   end
  # end
end

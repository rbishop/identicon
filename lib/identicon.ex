defmodule Identicon do
  @moduledoc """
    This library generates GitHub-like identicons.
    Given an input of a string you will receive a base64
    encoded png of 5x5 identicon for that string.
  """

  defstruct color: nil, hex: nil, hash: nil, grid: nil, points: nil

  @gray {241, 241, 241}
  @white {255, 255, 255}

  def render(input) do
    input 
    |> input_to_hash
    |> extract_color
    |> hash_to_grid
    |> compute_squares
    |> draw_image
  end

  def input_to_hash(string) do
    hash = :crypto.hash(:md5, String.to_char_list(string))
    hex = :binary.bin_to_list(hash)
    %Identicon{hex: hex, hash: decode(hash)}
  end

  def extract_color(%Identicon{hex: hex} = identicon) do
    [r, g, b | _] = hex
    %Identicon{identicon | color: {r, g, b}}
  end

  def hash_to_grid(%Identicon{hash: hash} = identicon) do
    grid = String.slice(hash, 6..30)
    |> String.split("")
    |> Enum.chunk(5)
    |> Enum.map(&Enum.with_index/1)
    |> Enum.with_index

    %Identicon{identicon | grid: grid}
  end

  def compute_squares(%Identicon{grid: grid} = identicon) do
    points = Enum.flat_map(grid, fn{cells, row} ->
      Enum.map(cells, fn({cell, column}) ->
        cell = string_to_int(cell)
        case rem(cell, 2) do
          0 ->
            top_left = {row * 50, column * 50}
            bottom_right = {row * 50 + 50, column * 50 + 50}
            {top_left, bottom_right}
          1 ->
            {}
        end
      end)
    end)

    %Identicon{identicon | points: points}
  end

  def draw_image(%Identicon{color: color, points: points}) do
    image = :egd.create(250, 250)
    color = :egd.color(color)
    background = :egd.color(@white)
    :egd.filledRectangle(image, {0, 0}, {250, 250}, background)

    draw = fn 
      {start, stop} ->
        :egd.filledRectangle(image, start, stop, color)
      {} ->
        nil
    end

    Enum.each(points, draw)
    :egd.render(image, :png) |> Base.encode64
  end

  # A quick implementation for decoding hexadecimal encoded
  # binaries into unicode binaries
  defp decode(bin), do: decode(bin, "")
  defp decode(<<>>, acc), do: acc
  defp decode(<<first::size(4), second::size(4), rest::binary>>, acc) do
    decode(rest, acc <> int_to_string(first) <> int_to_string(second))
  end

  defp int_to_string(int) when int <= 9, do: Integer.to_string(int)
  for {key, val} <- [{10, "a"}, {11, "b"}, {12, "c"}, {13, "d"}, {14, "e"}, {15, "f"}] do
    defp int_to_string(unquote(key)), do: unquote(val)
  end

  for int <- 0..9 do
    defp string_to_int(unquote(Integer.to_string(int))), do: unquote(int)
  end
  for {key, val} <- [{"a", 10}, {"b", 11}, {"c", 12}, {"d", 13}, {"e", 14}, {"f", 15}] do

    defp string_to_int(unquote(key)), do: unquote(val)
  end
end

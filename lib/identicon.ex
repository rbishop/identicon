defmodule Identicon do
  @moduledoc """
    This library generates GitHub-like identicons. Unlike
    GitHub's identicons, the identicons this library generates
    are not symmetrical.

    Given an input of a string you will receive a base64
    encoded png of 5x5 identicon for that string.
  """
  defstruct color: nil, hex_code: nil, grid: nil, md5: nil, pixels: nil

  def render(input) do
    input 
    |> hash_input
    |> extract_color
    |> build_grid
    |> calculate_pixels
    |> draw_image
  end

  defp hash_input(string) do
    hex_code = :crypto.hash(:md5, string) |> :binary.bin_to_list
    md5 = Enum.flat_map(hex_code, &(:io_lib.format("~2.16.0b", [&1]))) |> Enum.join("")
    %Identicon{hex_code: hex_code, md5: md5}
  end

  defp extract_color(%Identicon{hex_code: [r, g, b | _]} = identicon) do
    %Identicon{identicon | color: {r, g, b}}
  end

  defp build_grid(%Identicon{md5: md5} = identicon) do
    grid = String.slice(md5, 6..30)
    |> String.split("", trim: true)
    |> Enum.map(&(:erlang.binary_to_integer(&1, 16)))
    |> Enum.with_index
    |> Enum.filter(fn({code, _index}) -> rem(code, 2) == 0 end)

    %Identicon{identicon | grid: grid}
  end

  defp calculate_pixels(%Identicon{grid: grid} = identicon) do
    pixels = Enum.map(grid, fn({_code, index}) ->
      row = div(index, 5)
      column = rem(index, 5)

      top_left = {row * 50, column * 50}
      bottom_right = {row * 50 + 50, column * 50 + 50}
      {top_left, bottom_right}
    end)

    %Identicon{identicon | pixels: pixels}
  end

  defp draw_image(%Identicon{color: color, pixels: pixels}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each(pixels, fn({start, stop}) -> 
      :egd.filledRectangle(image, start, stop, fill)
    end)

    :egd.render(image, :png) |> Base.encode64
  end
end

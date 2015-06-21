defmodule Identicon do
  alias Identicon.Grid

  @moduledoc """
    This library generates GitHub-like, symmetrical identicons.

    Given an input of a string you will receive a base64
    encoded png of 5x5 identicon for that string.
  """
  defstruct color: nil, hex: nil, grid: nil, pixels: nil

  def render(input) do
    input 
    |> hash_input
    |> extract_color
    |> build_grid
    |> calculate_pixels
    |> draw_image
  end

  defp hash_input(string) do
    hex = :crypto.hash(:md5, string) |> :binary.bin_to_list
    %Identicon{hex: hex}
  end

  defp extract_color(%Identicon{hex: [r, g, b | _]} = identicon) do
    %Identicon{identicon | color: {r, g, b}}
  end

  # We remove the head of the hexadecimal list because we only need fifteen
  # bytes to generate the left side and center of the grid
  defp build_grid(%Identicon{hex: [_ | hex]} = identicon) do
    grid = hex
    |> Enum.chunk(3)
    |> Enum.flat_map(&Grid.mirror_row/1)
    |> Enum.with_index
    |> Enum.filter(fn({code, _index}) -> rem(code, 2) == 0 end)

    %Identicon{identicon | grid: grid}
  end

  defp calculate_pixels(%Identicon{grid: grid} = identicon) do
    pixels = Enum.map(grid, fn({_code, index}) ->
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50

      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}

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

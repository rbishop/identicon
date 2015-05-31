defmodule Identicon do
  @moduledoc """
    This library generates GitHub-like identicons.
    Given an input of a string you will receive a base64
    encoded png of 5x5 identicon for that string.
  """

  defstruct color: nil, hex: nil, grid: nil, md5: nil, points: nil

  def render(input) do
    input 
    |> hash_input
    |> extract_color
    |> build_grid
    |> calculate_squares
    |> draw_image
  end

  @spec hash_input(String.t) :: map(Identicon)
  def hash_input(string) do
    hex = :crypto.hash(:md5, string) |> :binary.bin_to_list
    md5 = Enum.flat_map(hex, &(:io_lib.format("~2.16.0b", [&1]))) |> Enum.join("")
    %Identicon{hex: hex, md5: md5}
  end

  def extract_color(%Identicon{hex: [r, g, b | _]} = identicon) do
    %Identicon{identicon | color: {r, g, b}}
  end

  def build_grid(%Identicon{md5: md5} = identicon) do
    grid = String.slice(md5, 6..30)
    |> String.split("", trim: true)
    |> Enum.map(&(:erlang.binary_to_integer(&1, 16)))
    |> Enum.chunk(5)
    |> Enum.map(&Enum.with_index/1)
    |> Enum.with_index

    %Identicon{identicon | grid: grid}
  end

  def calculate_squares(%Identicon{grid: grid} = identicon) do
    points = Enum.flat_map(grid, fn({cells, row}) ->
      Enum.map(cells, fn({cell, column}) ->
        case rem(cell, 3) do
          0 ->
            top_left = {row * 50, column * 50}
            bottom_right = {row * 50 + 50, column * 50 + 50}
            {top_left, bottom_right}
          _ ->
            {}
        end
      end)
      |> Enum.reject(&(&1 == {}))
    end)

    %Identicon{identicon | points: points}
  end

  def draw_image(%Identicon{color: color, points: points}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each(points, fn({start, stop}) -> 
      :egd.filledRectangle(image, start, stop, fill)
    end)

    :egd.render(image, :png) |> Base.encode64
  end
end

defmodule Identicon.Renderers.GitHubLike do
  @moduledoc """
    This library generates GitHub-like, symmetrical identicons.

    Given an input of a string you will receive a base64
    encoded png of a 5x5 identicon for that string.
  """

  alias Identicon.Renderers.GitHubLike.Grid
  alias Identicon.Renderers.GitHubLike.Struct
  import Identicon.Helper

  def render(input, :size_5x5) when is_bitstring(input) do
    result =
      input
      |> to_identicon
      |> add_hex
      |> add_color
      |> add_grid
      |> calculate_pixels
      |> draw_image

    {:ok, result}
  end
  def render(input, size) do
    {:error, emsg_invalid_args(%{expected: "String.t, :size_5x5", actual: [input, size]})}
  end

  defp to_identicon(input) do
    %Struct{input: input}
  end

  defp add_hex(%Struct{input: input}) do
    hex = :crypto.hash(:md5, input) |> :binary.bin_to_list
    %Struct{hex: hex}
  end

  defp add_color(%Struct{hex: [r, g, b | _]} = identicon) do
    %Struct{identicon | color: {r, g, b}}
  end

  # We remove the head of the hexadecimal list because we only need fifteen
  # bytes to generate the left side and center of the grid
  defp add_grid(%Struct{hex: [_ | hex], size: 5} = identicon) do
    grid =
      hex
      |> Grid.from_hex
      |> Grid.remove_odd_bytes
      
    %Struct{identicon | grid: grid}
  end

  defp calculate_pixels(%Struct{grid: grid} = identicon) do
    pixels = Enum.map(grid, fn({_code, index}) ->
      horizontal = rem(index, 5) * 50
      vertical = div(index, 5) * 50

      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}

      {top_left, bottom_right}
    end)

    %Struct{identicon | pixels: pixels}
  end

  defp draw_image(%Struct{color: color, pixels: pixels}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each(pixels, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end)

    :egd.render(image, :png) |> Base.encode64
  end
end

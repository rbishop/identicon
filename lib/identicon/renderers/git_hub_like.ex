defmodule Identicon.Renderers.GitHubLike do
  @moduledoc """
    This library generates GitHub-like, symmetrical identicons.
    
    This can do GitHub-like identicons with various sizes. 
    Given an input of a string you will receive a base64 encoded png of a
    sizexsize identicon for that string.
  """

  alias Identicon.Renderers.GitHubLike.Grid
  alias Identicon.Renderers.GitHubLike.Struct
  import Identicon.Helper

  def render(input, opts) when is_bitstring(input) do
    size = Keyword.get(opts, :size)
    result =
      input
      |> to_identicon(size)
      |> add_hash
      |> add_color
      |> add_grid
      |> calculate_pixels
      |> draw_image

    {:ok, result}
  end
  def render(input, size) do
    {:error, emsg_invalid_args(%{expected: "String.t, 5", actual: [input, size]})}
  end

  defp to_identicon(input, size) do
    %Struct{input: input, size: size}
  end

  defp add_hash(%Struct{input: input} = identicon) do
    hash = :crypto.hash(:md5, input) |> :binary.bin_to_list
    %Struct{identicon | hash: hash}
  end

  defp add_color(%Struct{hash: [r, g, b | _]} = identicon) do
    %Struct{identicon | color: {r, g, b}}
  end

  # We remove the head of the hexadecimal list because we only need fifteen
  # bytes to generate the left side and center of the grid
  defp add_grid(%Struct{hash: [_ | hash], size: size} = identicon) do
    grid =
      hash
      |> Grid.from_hex(size)
      |> Grid.remove_odd_bytes

    %Struct{identicon | grid: grid}
  end

  defp calculate_pixels(%Struct{grid: grid, size: size} = identicon) do
    pixel_size = 10 * size
    pixels = Enum.map(grid, fn({_code, index}) ->
      horizontal = rem(index, size) * pixel_size
      vertical = div(index, size) * pixel_size

      top_left = {horizontal, vertical}
      bottom_right = {horizontal + pixel_size, vertical + pixel_size}

      {top_left, bottom_right}
    end)

    %Struct{identicon | pixels: pixels}
  end

  defp draw_image(%Struct{color: color, pixels: pixels, size: size}) do
    len = 10 * size * size
    image = :egd.create(len, len)
    fill = :egd.color(color)

    Enum.each(pixels, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end)

    :egd.render(image, :png) |> Base.encode64
  end
end

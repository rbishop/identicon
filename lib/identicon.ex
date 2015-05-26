defmodule Identicon do
  @moduledoc """
    This library generates GitHub-like identicons.
    Given an input of a string you will receive a base64
    encoded png of 5x5 identicon for that string.
  """

  defstruct hash: nil, color: nil, pixels: []

  def render(string) do
    string
    |> md5
    |> extract_color
  end

  defp md5(string) do
    hash = :crypto.hash(:md5, String.to_char_list(string))
    %Identicon{hash: decode(hash)}
  end

  defp extract_color(%Identicon{hash: hash} = identicon) do
    color = String.slice(hash, 0..5)
    %Identicon{identicon | color: color}
  end

  # A quick implementation for decoding hexadecimal encoded
  # binaries into unicode binaries
  defp decode(bin), do: decode(bin, "")
  defp decode(<<>>, acc), do: acc
  defp decode(<<first::size(4), second::size(4), rest::binary>>, acc) do
    decode(rest, acc <> int_to_string(first) <> int_to_string(second))
  end

  defp int_to_string(int) when int <= 9, do: Integer.to_string(int)

  # Generate the integr to string conversions for integers that map to letters
  for {key, val} <- [{10, "a"}, {11, "b"}, {12, "c"}, {13, "d"}, {14, "e"}, {15, "f"}] do
    defp int_to_string(unquote(key)), do: unquote(val)
  end
end

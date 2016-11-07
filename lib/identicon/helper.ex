defmodule Identicon.Helper do
  @moduledoc """
  Helper functions for Identicon. Includes error messages, utils.
  """

  def emsg_invalid_args(%{expected: expected, actual: actual})
    when is_bitstring(expected) and is_bitstring(actual) do
    "Invalid args. Expected: #{expected}. Actual: #{actual}"
  end
  def emsg_invalid_args(%{expected: expected, actual: actual})
    when is_bitstring(expected) do
    "Invalid args. Expected: #{expected}. Actual: #{inspect actual}"
  end
  def emsg_invalid_args(%{expected: expected, actual: actual})
    when is_bitstring(actual) do
    "Invalid args. Expected: #{expected}. Actual: #{inspect actual}"
  end
  def emsg_invalid_args(%{expected: expected, actual: actual}) do
    "Invalid args. Expected: #{inspect expected}. Actual: #{inspect actual}"
  end
end

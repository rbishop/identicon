defmodule IdenticonTest do
  use ExUnit.Case

  test "turning the last 25 bytes of an md5 hash into a 5x5 grid" do
    id = Identicon.input_to_hash("Tracy")

    grid = Identicon.hash_to_grid(id)

    assert 5 == Enum.count(grid)
    Enum.each grid, fn(row) ->
      assert 5 == Enum.count(row)
    end
  end

  test "odd numbers are not turned into pixel points" do
    codes = [7, 12]

    [odd | _]  = Identicon.convert_hex_codes(codes)

    assert {} == odd
  end

  test "mapping an even numbered hex code to pixel points" do
    first_row = {[12, 1, 1, 1, 1], 0}
    
    [{top_left, bottom_right} | _]  = Identicon.hex_to_points

    assert {0, 0} == top_left
    assert {50, 50} == bottom_right

    last_row = {[12, 1, 1, 1], 4}

    [{top_left, bottom_right} | _] = Identicon.hex_to_points

    assert {200, 0} == top_left
    assert {50, 250} == bottom_right
  end
end

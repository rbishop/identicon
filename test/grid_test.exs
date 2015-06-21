defmodule GridTest do
  use ExUnit.Case
  alias Identicon.Grid

  test "mirrored rows of 5 values are generated from a list" do
    list = [1, 2, 2, 4, 1, 2]

    grid = Grid.from_hex list

    assert [
            {1, 0}, {2, 1}, {2, 2}, {2, 3}, {1, 4},
            {4, 5}, {1, 6}, {2, 7}, {1, 8}, {4, 9}
           ] == grid
  end

  test "mirroring with an odd number of columns" do
    row = [1, 2, 3]

    mirrored = Grid.mirror_row row

    assert [1, 2, 3, 2, 1] == mirrored
  end

  test "mirroring with an even number of columns" do
    row = [1, 2, 3, 4]

    mirrored = Grid.mirror_row row

    assert [1, 2, 3, 4, 4, 3, 2, 1] == mirrored
  end
end

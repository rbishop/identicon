defmodule GridTest do
  use ExUnit.Case
  alias Identicon.Grid

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

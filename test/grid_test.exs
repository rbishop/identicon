defmodule GridTest do
  use ExUnit.Case
  alias Identicon.Renderers.GitHubLike.Grid

  test "mirrored rows of 5 values are generated from a list" do
    list = [1, 2, 2,
            4, 1, 2,
            4, 1, 2,
            4, 1, 2,
            4, 1, 2
          ]

    grid = Grid.from_hex(list, 5)

    assert [
            {1, 0}, {2, 1}, {2, 2}, {2, 3}, {1, 4},
            {4, 5}, {1, 6}, {2, 7}, {1, 8}, {4, 9},
            {4, 10}, {1, 11}, {2, 12}, {1, 13}, {4, 14},
            {4, 15}, {1, 16}, {2, 17}, {1, 18}, {4, 19},
            {4, 20}, {1, 21}, {2, 22}, {1, 23}, {4, 24}
            
           ] == grid
  end

  test "mirroring with an odd number of columns, odd size" do
    row = [1, 2, 3]

    mirrored = Grid.mirror_row(row, 5)

    assert [1, 2, 3, 2, 1] == mirrored
  end

  test "mirroring with an odd number of columns, even size" do
    row = [1, 2, 3]

    mirrored = Grid.mirror_row(row, 6)

    assert [1, 2, 3, 3, 2, 1] == mirrored
  end

  test "mirroring with an even number of columns, odd size" do
    row = [1, 2, 3, 4]

    mirrored = Grid.mirror_row(row, 7)

    assert [1, 2, 3, 4, 3, 2, 1] == mirrored
  end

  test "mirroring with an even number of columns, even size" do
    row = [1, 2, 3, 4]

    mirrored = Grid.mirror_row(row, 8)

    assert [1, 2, 3, 4, 4, 3, 2, 1] == mirrored
  end
  
  test "adjust_list_to_fit_size - stay" do
    size = 10
    list = 0..49 |> Enum.to_list
    adjusted_list = Grid.adjust_list_to_fit_size(list, size)
    assert list === adjusted_list
  end

  test "adjust_list_to_fit_size - grow" do
    size = 10
    list = 0..42 |> Enum.to_list
    adjusted_list = Grid.adjust_list_to_fit_size(list, size)
    assert length(adjusted_list) === 50
  end
  
  test "adjust_list_to_fit_size - trunc" do
    size = 10
    list = 0..77 |> Enum.to_list
    adjusted_list = Grid.adjust_list_to_fit_size(list, size)
    assert length(adjusted_list) === 50
  end

end

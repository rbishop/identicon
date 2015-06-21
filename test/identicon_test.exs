defmodule IdenticonTest do
  use ExUnit.Case

  test "rendering is deterministic" do
    {:ok, image} = File.read("test/fixtures/elixir.png")
    image_base64 = Base.encode64(image)

    Enum.each 1..2, fn(_) ->
      generated_base64 = Identicon.render("Elixir")
      assert image_base64 == generated_base64
    end
  end
end

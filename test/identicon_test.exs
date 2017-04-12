defmodule IdenticonTest do
  use ExUnit.Case

  test "rendering is deterministic" do
    {:ok, image} = File.read("test/fixtures/elixir.png")
    image_base64 = Base.encode64(image)

    Enum.each 1..2, fn(_) ->
      generated_base64 = Identicon.render!("Elixir")
      assert image_base64 == generated_base64
    end
  end

  test "happy input is string" do
    {:ok, _result} = Identicon.render("some string")
  end
  
  test "happy input is string - bang" do
    _result = Identicon.render!("some string")
  end

  test "non-string input errors" do
    {:error, _reason} = Identicon.render(:not_a_string)
  end
  
  test "size 6 identicon" do
    Identicon.render!("Elixir6", size: 6)
  end
end

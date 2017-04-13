defmodule Identicon do
  @moduledoc """
  This is the primary module to create identicons.
  """

  alias Identicon.Renderers.GitHubLike
  import Identicon.Macros, only: [bang: 1]
  
  @default_renderer :githublike
  @default_size 5

  @doc """
  This is the main function for this library. It will produce the base64 encoded
  image bytes that you can then save as text.
  """
  @spec render(String.t|char_list, [] | [...]) :: {:ok, String.t} | {:error, String.t}
  def render(input, 
             opts \\ [type: @default_renderer, size: @default_size])
  def render(input, opts) when is_list(input) do
    render(to_string(input), opts)
  end
  # GitHubLike Renderer
  def render(input, [type: :githublike, size: size] = opts) do
    GitHubLike.render(input, opts)
  end
  def render(input, [type: :githublike]) do
    GitHubLike.render(input, [type: :githublike, size: @default_size])
  end
  def render(input, [size: size]) do
    GitHubLike.render(input, [type: :githublike, size: size])
  end
  def render(input, []) do
    render(input)
  end

  @doc """
  Bang version of `render/2`.
  """
  def render!(input, opts \\ []), do: render(input, opts) |> bang()
end

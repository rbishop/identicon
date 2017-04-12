defmodule Identicon do
  @moduledoc """
  This is the primary module to create identicons.
  """

  import Identicon.Macros, only: [bang: 1]
  
  @default_size 5

  @doc """
  
  """
  @spec render(String.t, [] | [...]) :: {:ok, String.t} | {:error, String.t}
  def render(input, opts \\ [type: :githublike, size: @default_size])
  # GitHubLike Renderer
  def render(input, [type: :githublike, size: size]) do
    Identicon.Renderers.GitHubLike.render(input, size)
  end
  def render(input, [type: :githublike]) do
    Identicon.Renderers.GitHubLike.render(input, @default_size)
  end
  def render(input, [size: size]) do
    Identicon.Renderers.GitHubLike.render(input, [type: :githublike, size: size])
  end
  def render(input, []) do
    render(input)
  end

  @doc """
  Bang version of `render/2`.
  """
  def render!(input, opts \\ []), do: render(input, opts) |> bang()
end

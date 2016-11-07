defmodule Identicon do
  @moduledoc """
  Defines both the Identicon struct and the facade with which to interact.
  """

  @doc """
  Takes in
  """
  @spec render(String.t, [] | [...]) :: {:ok, String.t} | {:error, String.t}
  def render(input, opts \\ [type: :githublike, size: :size_5x5])
  def render(input, type: :githublike, size: size) do
    Identicon.Renderers.GitHubLike.render(input, size)
  end
  def render(input, type: :githublike) do
    Identicon.Renderers.GitHubLike.render(input, :size_5x5)
  end
  def render(input, []) do
    render(input)
  end

  def render!(input, opts \\ [type: :githublike, size: :size_5x5])
  def render!(input, type: :githublike, size: size) do
    case Identicon.Renderers.GitHubLike.render(input, size) do
      {:ok, result} -> result
      {:error, error} -> raise error
    end
  end
  def render!(input, type: :githublike) do
    Identicon.Renderers.GitHubLike.render(input, :size_5x5)
  end
  def render!(input, []) do
    render(input)
  end
end

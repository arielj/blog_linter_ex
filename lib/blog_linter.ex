defmodule BlogLinter do
  @moduledoc """
  Documentation for `BlogLinter`.
  """

  @doc """
      iex> BlogLinter.clean_path("./blogposts")
      "blogposts"
  """
  def clean_path(path) do
    String.replace(path, ~r/.*\//, "")
  end

  def file_names(path) do
    path = clean_path(path)

    Path.wildcard("./#{path}/*.markdown")
    |> Enum.map(fn filename -> String.replace(filename, ~r/#{path}\//, "") end)
  end

  def process_path(path) do
    file_names(path)
    |> Enum.map(fn filename -> process_file(path, filename) end)
  end

  def process_file(path, filename) do
    read_content(path, filename)

    # errors =
    #   [] # errors in path/filename
    #   |> check_author(content)
    #   |> check_categories(content)

    # {filename, errors}
  end

  def read_content(path, filename) do
    case File.read("#{path}/#{filename}") do
      {:ok, content} -> content
      {:error, _} -> "Error"
    end
  end

  # def check_author(errors, content) do
  #   ....
  #   case has_valid_author do
  #     {:ok, _} -> errors
  #     {:error, reason} -> [reason | errors]
  #   end
  # end

  # def check_catetories(errors, content) do
  #   ....
  #   case has_valid_categories do
  #     {:ok, _} -> errors
  #     {:error, reason} -> [reason | errors]
  #   end
  # end
end

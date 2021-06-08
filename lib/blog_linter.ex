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
    file_names(path) # ["post1.markdown", "post2.markdown"]
    |> Enum.map(fn filename -> process_file(path, filename) end)

    # TODO: the last function will produce a list of {filename, list_of_errors}
    # we have to process that list, display errors if any and change the exit
    # code of the script
  end

  def process_file(path, filename) do
    case File.read("#{path}/#{filename}") do
      {:ok, content} -> {filename, check_errors(content)}
      {:error, reason} -> {filename, reason}
    end
  end

  def check_errors(content) do
    metadata = extract_metadata(content)

    []
    |> check_layout(metadata)
    |> check_author(metadata)
  end

  def extract_metadata(content) do
    metadata_string =
      hd(hd(Regex.scan(~r/---.*---/s, content)))
      |> String.replace(~r/\n?---\n?/, "")


    case YamlElixir.read_from_string(metadata_string) do
      {:ok, yaml_map} -> yaml_map
    end
  end

  @spec check_layout(any, any) :: any
  @doc """
      iex> BlogLinter.check_layout([], %{"layout" => "post", author: ""})
      []
      iex> BlogLinter.check_layout([], %{"layout" => "landing", author: ""})
      ["Layout must be post"]
      iex> BlogLinter.check_layout([], %{})
      ["Layout must be post"]
  """
  def check_layout(errors, %{"layout" => "post"}), do: errors
  def check_layout(errors, _), do: ["Layout must be post" | errors]

  @doc """
      iex> BlogLinter.check_author(["errors"], %{"author" => "José Valim"})
      ["errors"]
      iex> BlogLinter.check_author([], %{"author" => ""})
      ["Author must be present"]
  """
  def check_author(errors, %{"author" => author}) when is_binary(author) and author != "" do
    errors
  end
  def check_author(errors, %{"author" => _}), do: ["Author must be present" | errors]

  # TODO: Validate `authors` key
  # def check_author(errors, %{authors: authors}) when valid_authors(authors) do
  #   errors
  # end

  @doc """
      iex> BlogLinter.valid_authors(["José Valim", "Joe Armstrong"])
      true
      iex> BlogLinter.valid_authors([])
      false
  """
  def valid_authors([author|[]]), do: true
  def valid_authors([author|authors]) when is_binary(author) do
    valid_authors(authors)
  end
  def valid_authors(x), do: false

  # TODO: add a generic check_author function to catch if both author and authors keys are missing
end

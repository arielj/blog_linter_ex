defmodule BlogLinterTest do
  use ExUnit.Case
  doctest BlogLinter

  test "reads the files in a given path" do
    assert BlogLinter.file_names("./blogposts") == ["post1.markdown", "post2.markdown"]
  end

  test "reads the content of a file" do
    content = BlogLinter.process_file("./blogposts", "post1.markdown")
    assert content != ""
  end
end

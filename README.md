# BlogLinter

Small Elixir app that checks all files in a directory for missing metadata to practice the Elixir lang.

## Installation

1. Clone repo

2. `cd blog_linter`

3. Download any dependency with:

```sh
$ mix deps.get
```

4. Run the main script with:

```sh
$ mix run main.ex
["post1.markdown", "post2.markdown"]
```

## TODO

- For each file:
  - check all meta data in the --- yaml --- section
  - check the `<!-- more -->` comment is present
  - validate that the post metadata image file actually exists
- Process all files:
- Return failures

## Recommendations

- Add linting for the code editor using Credo
- Add the elixir language server extension for your code editor

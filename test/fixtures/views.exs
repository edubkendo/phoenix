defmodule MyApp.View do
  use Phoenix.View, root: "test/fixtures/templates"

  using do
    use Phoenix.HTML
  end

  def escaped_title(title) do
    safe html_escape title
  end
end

defmodule MyApp.LayoutView do
  use MyApp.View

  def default_title do
    "MyApp"
  end
end

defmodule MyApp.UserView do
  use MyApp.View
end

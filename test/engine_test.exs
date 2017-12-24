defmodule PhoenixMarkdown.EngineTest do
  use ExUnit.Case
  alias PhoenixMarkdown.Engine

  #============================================================================
  # vanilla markdown

  test "compile a vanilla markdown template with smart tags turned off" do
    Mix.Config.persist(phoenix_markdown: [smart_tags: false])
    data = "test/fixtures/templates/view_test/my_app/page/sample.html.md"
    |> Engine.compile("sample.html")
    assert data == {
      :safe,
      [{:|, [], ["", "<h2>Sample <em>template</em> <strong>in</strong> Markdown</h2>\n"]}]
    }
  end

  test "compile a vanilla markdown template with smart_tags turned on" do
    Mix.Config.persist(phoenix_markdown: [smart_tags: true])
    data = "test/fixtures/templates/view_test/my_app/page/sample.html.md"
    |> Engine.compile("sample.html")
    assert data == {:safe, [{:|, [], ["", "<h2>Sample <em>template</em> <strong>in</strong> Markdown</h2>\n"]}]}
  end

  #============================================================================
  # basic smart tags

  test "compile a smart template with smart tags turned off" do
    Mix.Config.persist(phoenix_markdown: [smart_tags: false])
    data = "test/fixtures/templates/view_test/my_app/page/smart_sample.html.md"
    |> Engine.compile("smart_sample.html")
    assert data == {:safe, [{:|, [], ["", "<h2>Smart</h2>\n<p>&lt;% 11 + 1 %&gt;\n&lt;%= 11 + 2 %&gt;\n&lt;%% 11 + 3 %&gt;\n&lt;%# 11 + 4 %&gt;\nfin</p>\n"]}]}
  end

  test "compile a smart template with smart tags turned off with a nil" do
    Mix.Config.persist(phoenix_markdown: [smart_tags: nil])
    data = "test/fixtures/templates/view_test/my_app/page/smart_sample.html.md"
    |> Engine.compile("smart_sample.html")
    assert data == {:safe, [{:|, [], ["", "<h2>Smart</h2>\n<p>&lt;% 11 + 1 %&gt;\n&lt;%= 11 + 2 %&gt;\n&lt;%% 11 + 3 %&gt;\n&lt;%# 11 + 4 %&gt;\nfin</p>\n"]}]}
  end

  test "compile a smart template with smart tags turned on with true" do
    Mix.Config.persist(phoenix_markdown: [smart_tags: true])
    data = "test/fixtures/templates/view_test/my_app/page/smart_sample.html.md"
    |> Engine.compile("smart_sample.html")
    assert data == {:safe, [{:|, [], [{:__block__, [], [{:=, [], [{:tmp1, [], Phoenix.HTML.Engine}, [{:|, [], [{:__block__, [], [{:=, [], [{:tmp2, [], Phoenix.HTML.Engine}, [{:|, [], ["", "<h2>Smart</h2>\n<p>"]}]]}, {:+, [line: 2], [11, 1]}, {:tmp2, [], Phoenix.HTML.Engine}]}, "\n"]}]]}, [{:|, [], [{:tmp1, [], Phoenix.HTML.Engine}, {:case, [generated: true], [{:+, [line: 3], [11, 2]}, [do: [{:->, [generated: true], [[safe: {:data, [generated: true], Phoenix.HTML.Engine}], {:data, [generated: true], Phoenix.HTML.Engine}]}, {:->, [generated: true], [[{:when, [generated: true], [{:bin, [generated: true], Phoenix.HTML.Engine}, {:is_binary, [generated: true, context: Phoenix.HTML.Engine, import: Kernel], [{:bin, [generated: true], Phoenix.HTML.Engine}]}]}], {{:., [generated: true], [{:__aliases__, [generated: true, alias: false], [:Plug, :HTML]}, :html_escape]}, [generated: true], [{:bin, [generated: true], Phoenix.HTML.Engine}]}]}, {:->, [generated: true], [[{:other, [generated: true], Phoenix.HTML.Engine}], {{:., [line: 3], [{:__aliases__, [line: 3, alias: false], [:Phoenix, :HTML, :Safe]}, :to_iodata]}, [line: 3], [{:other, [line: 3], Phoenix.HTML.Engine}]}]}]]]}]}]]}, "\n<% 11 + 3 %>\n\nfin</p>\n"]}]}
  end

  test "compile a smart template with smart tags turned on with :all" do
    Mix.Config.persist(phoenix_markdown: [smart_tags: :all])
    data = "test/fixtures/templates/view_test/my_app/page/smart_sample.html.md"
    |> Engine.compile("smart_sample.html")
    assert data == {:safe, [{:|, [], [{:__block__, [], [{:=, [], [{:tmp1, [], Phoenix.HTML.Engine}, [{:|, [], [{:__block__, [], [{:=, [], [{:tmp2, [], Phoenix.HTML.Engine}, [{:|, [], ["", "<h2>Smart</h2>\n<p>"]}]]}, {:+, [line: 2], [11, 1]}, {:tmp2, [], Phoenix.HTML.Engine}]}, "\n"]}]]}, [{:|, [], [{:tmp1, [], Phoenix.HTML.Engine}, {:case, [generated: true], [{:+, [line: 3], [11, 2]}, [do: [{:->, [generated: true], [[safe: {:data, [generated: true], Phoenix.HTML.Engine}], {:data, [generated: true], Phoenix.HTML.Engine}]}, {:->, [generated: true], [[{:when, [generated: true], [{:bin, [generated: true], Phoenix.HTML.Engine}, {:is_binary, [generated: true, context: Phoenix.HTML.Engine, import: Kernel], [{:bin, [generated: true], Phoenix.HTML.Engine}]}]}], {{:., [generated: true], [{:__aliases__, [generated: true, alias: false], [:Plug, :HTML]}, :html_escape]}, [generated: true], [{:bin, [generated: true], Phoenix.HTML.Engine}]}]}, {:->, [generated: true], [[{:other, [generated: true], Phoenix.HTML.Engine}], {{:., [line: 3], [{:__aliases__, [line: 3, alias: false], [:Phoenix, :HTML, :Safe]}, :to_iodata]}, [line: 3], [{:other, [line: 3], Phoenix.HTML.Engine}]}]}]]]}]}]]}, "\n<% 11 + 3 %>\n\nfin</p>\n"]}]}
  end

  #============================================================================
  # smart tags via :only tag

  test "compile a smart template with smart tags turned on with :only" do
    Mix.Config.persist(phoenix_markdown: [smart_tags: :all])
    data = "test/fixtures/templates/view_test/my_app/page/smart_sample.html.md"
    |> Engine.compile("smart_sample.html")
    assert data == {:safe, [{:|, [], [{:__block__, [], [{:=, [], [{:tmp1, [], Phoenix.HTML.Engine}, [{:|, [], [{:__block__, [], [{:=, [], [{:tmp2, [], Phoenix.HTML.Engine}, [{:|, [], ["", "<h2>Smart</h2>\n<p>"]}]]}, {:+, [line: 2], [11, 1]}, {:tmp2, [], Phoenix.HTML.Engine}]}, "\n"]}]]}, [{:|, [], [{:tmp1, [], Phoenix.HTML.Engine}, {:case, [generated: true], [{:+, [line: 3], [11, 2]}, [do: [{:->, [generated: true], [[safe: {:data, [generated: true], Phoenix.HTML.Engine}], {:data, [generated: true], Phoenix.HTML.Engine}]}, {:->, [generated: true], [[{:when, [generated: true], [{:bin, [generated: true], Phoenix.HTML.Engine}, {:is_binary, [generated: true, context: Phoenix.HTML.Engine, import: Kernel], [{:bin, [generated: true], Phoenix.HTML.Engine}]}]}], {{:., [generated: true], [{:__aliases__, [generated: true, alias: false], [:Plug, :HTML]}, :html_escape]}, [generated: true], [{:bin, [generated: true], Phoenix.HTML.Engine}]}]}, {:->, [generated: true], [[{:other, [generated: true], Phoenix.HTML.Engine}], {{:., [line: 3], [{:__aliases__, [line: 3, alias: false], [:Phoenix, :HTML, :Safe]}, :to_iodata]}, [line: 3], [{:other, [line: 3], Phoenix.HTML.Engine}]}]}]]]}]}]]}, "\n<% 11 + 3 %>\n\nfin</p>\n"]}]}
  end

  test "compile a smart template with smart tags turned on with :only - but with a miss" do
    Mix.Config.persist(phoenix_markdown: [smart_tags: {:only, ["other.html"]}])
    data = "test/fixtures/templates/view_test/my_app/page/smart_sample.html.md"
    |> Engine.compile("smart_sample.html")
    assert data == {:safe, [{:|, [], ["", "<h2>Smart</h2>\n<p>&lt;% 11 + 1 %&gt;\n&lt;%= 11 + 2 %&gt;\n&lt;%% 11 + 3 %&gt;\n&lt;%# 11 + 4 %&gt;\nfin</p>\n"]}]}
  end

  #============================================================================
  # smart tags via :except tag

  test "compile a smart template with smart tags turned on with :except" do
    Mix.Config.persist(phoenix_markdown: [smart_tags: {:except, ["smart_sample.html"]}])
    data = "test/fixtures/templates/view_test/my_app/page/smart_sample.html.md"
    |> Engine.compile("smart_sample.html")
    assert data == {:safe, [{:|, [], ["", "<h2>Smart</h2>\n<p>&lt;% 11 + 1 %&gt;\n&lt;%= 11 + 2 %&gt;\n&lt;%% 11 + 3 %&gt;\n&lt;%# 11 + 4 %&gt;\nfin</p>\n"]}]}
  end

  test "compile a smart template with smart tags turned on with :except - but with a miss" do
    Mix.Config.persist(phoenix_markdown: [smart_tags: {:except, ["other.html"]}])
    data = "test/fixtures/templates/view_test/my_app/page/smart_sample.html.md"
    |> Engine.compile("smart_sample.html")
    assert data == {:safe, [{:|, [], [{:__block__, [], [{:=, [], [{:tmp1, [], Phoenix.HTML.Engine}, [{:|, [], [{:__block__, [], [{:=, [], [{:tmp2, [], Phoenix.HTML.Engine}, [{:|, [], ["", "<h2>Smart</h2>\n<p>"]}]]}, {:+, [line: 2], [11, 1]}, {:tmp2, [], Phoenix.HTML.Engine}]}, "\n"]}]]}, [{:|, [], [{:tmp1, [], Phoenix.HTML.Engine}, {:case, [generated: true], [{:+, [line: 3], [11, 2]}, [do: [{:->, [generated: true], [[safe: {:data, [generated: true], Phoenix.HTML.Engine}], {:data, [generated: true], Phoenix.HTML.Engine}]}, {:->, [generated: true], [[{:when, [generated: true], [{:bin, [generated: true], Phoenix.HTML.Engine}, {:is_binary, [generated: true, context: Phoenix.HTML.Engine, import: Kernel], [{:bin, [generated: true], Phoenix.HTML.Engine}]}]}], {{:., [generated: true], [{:__aliases__, [generated: true, alias: false], [:Plug, :HTML]}, :html_escape]}, [generated: true], [{:bin, [generated: true], Phoenix.HTML.Engine}]}]}, {:->, [generated: true], [[{:other, [generated: true], Phoenix.HTML.Engine}], {{:., [line: 3], [{:__aliases__, [line: 3, alias: false], [:Phoenix, :HTML, :Safe]}, :to_iodata]}, [line: 3], [{:other, [line: 3], Phoenix.HTML.Engine}]}]}]]]}]}]]}, "\n<% 11 + 3 %>\n\nfin</p>\n"]}]}
  end

end

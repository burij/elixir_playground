defmodule Mix.Tasks.RunCli do
  use Mix.Task
  @shortdoc "App runner"

  @impl Mix.Task
  def run(_) do
    Mix.Task.run("app.start")

    IO.puts("""
    ----------------------------------------------------------------------------
    """)

    PlayApp.CliMenu.run()
  end
end

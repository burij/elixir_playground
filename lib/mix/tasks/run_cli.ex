defmodule Mix.Tasks.RunCli do
  use Mix.Task
  @shortdoc "App runner"

  @impl Mix.Task
  def run(_) do
    Mix.Task.run("app.start")

    PlayApp.Utils.draw_line(
      PlayApp.conf().separator,
      PlayApp.conf().terminal_width
    )

    CliMenu.run()
  end
end

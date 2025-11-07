defmodule PlayApp do
  def start(_type, _args) do
    Task.start_link(fn ->
      :ok = CliMenu.run()
      :init.stop()
    end)

    {:ok, self()}
  end

  def get_separator do
    Application.get_env(:play_app, :separator, "-")
  end

  def get_terminal_width do
    Application.get_env(:play_app, :terminal_width, 80)
  end
end

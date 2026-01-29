defmodule Script do
  def run do
    IO.puts("Server upgrade script is launching!")
    get_commands() |> execute()
  end

  defp get_commands do
    [
      "cd /srv/config",
      "docker compose pull",
      "docker compose up -d",
      "sleep 20",
      "docker image prune -f"
    ]
  end

  defp execute(commands) do
    Enum.map(commands, fn cmd ->
      IO.puts("> #{cmd}")

      case System.shell(cmd, into: IO.stream(:stdio, :line)) do
        {_, 0} -> IO.puts("ok!")
        {_, code} -> IO.puts("something went wrong. exit code: #{code}")
      end
    end)
  end
end

Script.run()

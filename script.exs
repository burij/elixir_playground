defmodule Script do
  def run do
    IO.puts("Server upgrade script is launching!")
    get_commands() |> execute()
    IO.puts("do not forget to start nextcloud")
    IO.puts("https://box:8080")
  end

  defp _get_stamp do
    Date.utc_today()
    |>Date.to_string()
  end

  defp get_commands do
    pr_dir = "/srv/config"

    [
      "cd #{pr_dir};sudo docker compose pull",
      "docker images --format '{{.Repository}}:{{.Tag}}' | xargs -L1 docker pull;",
      "cd #{pr_dir};sudo docker compose up -d --force-recreate --remove-orphans",
      "sleep 20",
      "sudo docker image prune -af",
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

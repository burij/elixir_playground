defmodule Script do
  def run do
    IO.puts("Server upgrade script is launching!")
    get_commands() |> execute()
    IO.puts("do not forget to start nextcloud!")
    IO.puts("https://box:8080")
  end

  defp get_date do
    Date.utc_today()
    |>Date.to_string()
  end

  defp get_commands do
    pr_dir = "/srv/config"
    opts = "--force-recreate --remove-orphans"
    sterm = "{{.Repository}}:{{.Tag}}"
    stamp = get_date() <> "_burij_Sicherung_"

    [
      "sudo tar -zcvf /srv/backups/#{stamp}config.tar.gz #{pr_dir}",
      "sudo zip -r /srv/backups/#{stamp}volumes /srv/docker/volumes",
      "sudo docker stop $(sudo docker ps -a -q); ",
      "cd #{pr_dir};sudo docker compose pull",
      "docker images --format '#{sterm}' | xargs -L1 docker pull;",
      "cd #{pr_dir};sudo docker compose up -d #{opts}",
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

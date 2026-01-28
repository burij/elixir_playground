defmodule Script do
  defp get_commands do
    [
      {"docker", ["compose", "pull"], cd: "/srv/config"},
      {"docker", ["compose", "up", "-d"], cd: "/srv/config"},
      {"sleep", ["20"]},
      {"docker", ["image", "prune", "-f"], cd: "/srv/config"}
    ]
  end

  defp execute(command_list) do
    command_list
    |> Enum.map(fn {cmd, args} ->
      IO.puts("Running: #{cmd} #{Enum.join(args, " ")}")

      case System.cmd(cmd, args, stderr_to_stdout: true) do
        {output, 0} -> {:ok, output}
        {output, exit_code} -> {:error, exit_code, output}
      end
    end)
  end

  defp message(ok: output) do
    IO.puts("OK!")
    IO.puts(output)
  end

  defp message([{:error, exit_code, output}]) do
    IO.puts("Something went wrong!")
    IO.puts("Exit code:")
    IO.puts(exit_code)
    IO.puts(output)
  end

  def run do
    IO.puts("Server upgrade script is launching!")
    get_commands() |> execute() |> message()
  end
end

Script.run()

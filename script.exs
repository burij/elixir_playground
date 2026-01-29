defmodule Script do
  def run do
    IO.puts("Server upgrade script is launching!")
    get_commands() |> execute() |> message()
  end

  defp get_commands do
    [
      {"docker", ["compose", "pull"], cd: "/srv/config"},
      {"docker", ["compose", "up", "-d"], cd: "/srv/config"},
      {"sleep", ["20"]},
      {"docker", ["image", "prune", "-f"], cd: "/srv/config"}
    ]
  end

  defp execute(command_list) do
    Enum.reduce_while(command_list, :ok, fn {cmd, args, opts}, _acc ->
      IO.puts("Running: #{cmd} #{Enum.join(args, " ")}")

      case System.cmd(cmd, args, Keyword.put_new(opts, :stderr_to_stdout, true)) do
        {output, 0} ->
          IO.puts(output)
          {:cont, :ok}
        {output, exit_code} ->
          {:halt, {:error, exit_code, output}}
      end
    end)
  end

  defp message(:ok) do
    IO.puts("OK!")
  end

  defp message([{:error, exit_code, output}]) do
    IO.puts("Something went wrong!")
    IO.puts("Exit code: #{exit_code}")
    IO.puts(output)
  end
end

Script.run()

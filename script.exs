defmodule Script do
  def get_commands do
    [
    {"git", ["status"]}
    ]
  end

  def execute(command_list) do
    command_list
    |> Enum.map(fn {cmd, args} ->
      IO.puts("Running: #{cmd} #{Enum.join(args, " ")}")

      case System.cmd(cmd, args, stderr_to_stdout: true) do
        {output, 0} -> {:ok, output}
        {output, exit_code} -> {:error, exit_code, output}
      end
    end)
  end
end

Script.get_commands() |> Script.execute() |> IO.puts()


# IO.puts("Server upgrade script is launching!")

# {output, _} = System.cmd("docker", ["compose", "pull"], cd: "/srv/config")
# IO.puts(output)

# {output, _} = System.cmd("docker", ["compose", "up", "-d"], cd: "/srv/config")
# IO.puts(output)

# {_, _} = System.cmd("sleep", ["20"])

# {output, _} = System.cmd("docker", ["image", "prune", "-f"], cd: "/srv/config")
# IO.puts(output)
defmodule IdeasDB do
  def read do
    _ideas =
      File.read!("ideas.dat")
      |> :erlang.binary_to_term()
  end

  def write(input) do
    idea_entry = construct_entry(input)
    ideas_list = idea_entry ++ read()
    result = :erlang.term_to_binary(ideas_list)
    File.write!("ideas.dat", result)
    IO.puts("Your idea '#{input}' has been saved...")
  end

  defp construct_entry(input) do
    result = %{
      id: :crypto.strong_rand_bytes(2) |> Base.encode16(case: :lower),
      content: input,
      votes: 1
    }

    [result]
  end
end

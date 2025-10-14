defmodule IdeasDB do
  def read do
    case File.read("ideas.dat") do
      {:ok, data} ->
        :erlang.binary_to_term(data)

      {:error, _reason} ->
        []
    end
  end

  def add(input) do
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

  def rewrite(input) do
    db = :erlang.term_to_binary(input)
    File.write!("ideas.dat", db)
    IO.puts("Changes saved...")
  end
end

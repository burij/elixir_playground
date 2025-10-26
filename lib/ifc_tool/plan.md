## 1\. The ID/Content Parsing Strategy

The goal is to transform the flat IFC file content into a structured list where each element is easily searchable and contains the raw entity definition.

### **Transformation Goal:**

| File Line (Raw) | Elixir Structure (List of Maps/Structs) |
| :--- | :--- |
| `#1=IFCPROJECT(...);` | `%{id: 1, type: "IFCPROJECT", content: "(<parameters>)"}` |
| `#2=IFCOWNERHISTORY(...);` | `%{id: 2, type: "IFCOWNERHISTORY", content: "(<parameters>)"}` |

### **Implementation Steps in Elixir**

This can be accomplished using **streaming** and a single, robust regular expression:

### Step 1: Read and Split the File

Use `File.stream!/3` to read the file line-by-line, which is crucial for handling large IFC files without exhausting memory.

```elixir
def parse_to_raw_entities(file_path) do
  File.stream!(file_path, [], :line)
  |> Stream.filter(&String.starts_with?(&1, "#")) # Focus on entity lines
  |> Stream.flat_map(&extract_entity/1) # Process each line
  |> Enum.to_list()
end
```

### Step 2: Extract ID and Raw Content

You need a regular expression to capture the three key parts of the line: the ID, the entity type, and the raw parameter string.

**Regex Pattern:**

```regex
^#(\d+)=(\w+)\((.*)\);
```

  * `^#`: Start of line followed by `#`.
  * `(\d+)`: Capture Group 1 (the **ID** number).
  * `=`: The literal equals sign.
  * `(\w+)`: Capture Group 2 (the **ENTITY\_TYPE**, e.g., `IFCWALL`).
  * `\(`: The opening parenthesis.
  * `(.*)`: Capture Group 3 (the **RAW PARAMETER STRING**). This is the key part—it captures *everything* inside the parentheses.
  * `\);`: The closing parenthesis and semicolon.

**Elixir Extraction Function:**

```elixir
defp extract_entity(line) do
  regex = ~r/^#(\d+)=(\w+)\((.*)\);/

  case Regex.run(regex, line, capture: :all) do
    [_, id_str, type_str, content] ->
      [
        %{
          id: String.to_integer(id_str),
          type: type_str,
          content: content,
          # Store the original raw line for re-writing later
          original_line: String.trim_trailing(line)
        }
      ]
    _ ->
      # Ignore header lines, comments, or malformed lines
      []
  end
end
```

-----

## 2\. Searching and Modifying (The Targeted Change)

With the data now in a structured format, you can use Elixir's pattern matching and string functions to find and replace specific parameters.

### **Example: Renaming an `IFCPROJECT`**

A project name is typically the second or third parameter in the `IFCPROJECT` entity. If you know the exact location (e.g., the name is the third parameter), you can use a targeted regex search on the `content` string.

1.  **Find the Target Entity:**

    ```elixir
    target_entity =
      parsed_data
      |> Enum.find(fn entity -> entity.type == "IFCPROJECT" end)
    ```

2.  **Modify the Raw Content:**

    The content string might look like this: `IFCGLOBALLYUNIQUEID('001'),#3,'Old Project Name',$,$,#6`

    To replace the third parameter (the name), you need a regex that matches the string parameter while respecting the surrounding commas. This is still simpler than full parsing.

    ```elixir
    def update_project_name(entity, new_name) do
      # Target the third parameter (the name string, which starts with a quote)
      # This is still a complex regex to get right, relying on known IFC structure
      # A simple approach for this example is splitting, modifying, and joining:
      parts = String.split(entity.content, ",")
      new_parts = List.update_at(parts, 2, fn _old_name -> "'#{new_name}'" end)
      new_content = Enum.join(new_parts, ",")

      %{entity | content: new_content}
    end
    ```

-----

## 3\. Rebuilding the IFC File

This is the most critical step to ensure a valid output file.

1.  **Iterate and Recreate the Line:** Iterate through the **modified** list of maps and reconstruct the IFC entity line (`#ID=ENTITY_TYPE(CONTENT);`).

    ```elixir
    def serialize_entity(entity) do
      # Format the modified entity back into the line structure
      "#${entity.id}=${entity.type}(${entity.content});\n"
    end
    ```

2.  **Combine Header and Data:**

      * You must preserve the **original header** exactly as it was.
      * Iterate over the original file lines again.
      * When you encounter a `DATA` section entity line (`#ID...`), replace it with the serialized string from your modified list.
      * Otherwise, write the original line.

This "read-modify-replace" streaming technique prevents file corruption and is highly efficient for targeted updates.

**Conclusion:** Your strategy of parsing to **ID, Type, and Raw Content** is the best path forward for an Elixir project focused on punctual modifications, offering excellent performance and greatly reduced implementation complexity compared to a full geometric parser.

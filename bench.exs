l = Enum.map(1..1000, fn i -> i end)
v = Vec.from_list(l)


ll = Enum.map(1..10_000, fn i -> i end)
vv = Vec.from_list(ll)

Benchee.run(
  %{
    "Vec.new()" => fn ->
      Vec.new()
    end,
    "List prepend 1000" => fn ->
      Enum.reduce(1..1000, [], fn i, acc ->
        [i | acc]
      end)
    end,
    "Vec.push/1 1000" => fn ->
      Enum.reduce(1..1000, Vec.new(), fn i, acc ->
        Vec.push(acc, i)
      end)
    end,
    "Vec.push/1 1000 with_capacity" => fn ->
      Enum.reduce(1..1000, Vec.with_capacity(1000), fn i, acc ->
        Vec.push(acc, i)
      end)
    end,
    "Vec.from_list/1 1000" => fn ->
      Vec.from_list(l)
    end,

    # 1000
    "List.last/1 1000" => fn ->
      List.last(l)
    end,
    "Vec.last/1 1000" => fn ->
      Vec.last(v)
    end,
    "List.replace_at/3 1000" => fn ->
      List.replace_at(l, 499, :ok)
    end,
    "Vec.set_at/3 1000" => fn ->
      Vec.set_at(v, 499, :ok)
    end,
    "Enum.at/3 1000" => fn ->
      Enum.at(l, 499)
    end,
    "Vec.at/3 1000" => fn ->
      Vec.at(v, 499)
    end,

    # 10_000
    "List.last/1 10000" => fn ->
      List.last(ll)
    end,
    "Vec.last/1 10000" => fn ->
      Vec.last(vv)
    end,
    "List.replace_at/3 10000" => fn ->
      List.replace_at(ll, 4999, :ok)
    end,
    "Vec.set_at/3 10000" => fn ->
      Vec.set_at(vv, 4999, :ok)
    end,
    "Enum.at/3 10000" => fn ->
      Enum.at(ll, 4999)
    end,
    "Vec.at/3 10000" => fn ->
      Vec.at(vv, 4999)
    end,
  }
)

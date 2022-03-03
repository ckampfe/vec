defmodule VecTest do
  use ExUnit.Case
  doctest Vec

  test "new/0" do
    v = Vec.new()
    assert v
  end

  test "with_capacity/1 and capacity/1" do
    v = Vec.with_capacity(1000)
    assert Vec.count(v) == 0
    assert Vec.capacity(v) == 1000
  end

  test "count/1" do
    v = Vec.new()
    assert Vec.count(v) == 0
  end

  test "push/2" do
    v = Vec.new()
    v = Vec.push(v, "hi")
    assert Vec.count(v) == 1
  end

  test "member?/2" do
    v = Vec.new()
    v = Vec.push(v, "hi")
    assert Vec.member?(v, "hi")
    refute Vec.member?(v, "not in the vec")
  end

  test "empty?/1" do
    v = Vec.new()
    assert Vec.empty?(v)

    v = Vec.new()
    v = Vec.push(v, "hi")
    assert !Vec.empty?(v)
  end

  test "clear/1" do
    v = Vec.new()
    v = Vec.push(v, "hi")
    assert Vec.member?(v, "hi")
    v = Vec.clear(v)
    refute Vec.member?(v, "hi")
    assert Vec.count(v) == 0
  end

  test "last/1" do
    v = Vec.new()
    v = Vec.push(v, "hi")
    assert Vec.last(v) == "hi"
  end

  test "last/2" do
    v = Vec.new()
    assert Vec.last(v, :some_provided_default) == :some_provided_default
  end

  test "to_list/1" do
    v = Vec.new()
    assert Vec.to_list(v) == []

    v = Vec.new()
    v = Vec.push(v, "hi")
    assert Vec.to_list(v) == ["hi"]
  end

  test "from_list/1" do
    v = Vec.from_list([1, 2, 3])
    assert Vec.to_list(v) == [1, 2, 3]
  end

  test "at/3" do
    v = Vec.from_list([1, 2, 3])
    assert Vec.to_list(v) == [1, 2, 3]
    assert Vec.at(v, 1) == 2

    v = Vec.from_list([1, 2, 3])
    assert Vec.at(v, 1000, :some_provided_default) == :some_provided_default
  end

  test "set_at/3" do
    v = Vec.from_list([1, 2, 3])
    assert Vec.to_list(v) == [1, 2, 3]
    v = Vec.set_at(v, 1, 99)
    assert Vec.to_list(v) == [1, 99, 3]
  end

  test "equals?/2" do
    v1 = Vec.from_list([1, 2, 3])
    v2 = Vec.from_list([1, 2, 3])
    v3 = Vec.from_list([:a, :b, :c])

    assert Vec.equals?(v1, v1)
    assert Vec.equals?(v2, v2)
    assert Vec.equals?(v1, v2)
    refute Vec.equals?(v1, v3)
    refute Vec.equals?(v2, v3)
  end

  test "Collectable" do
    v1 = Enum.into([1, 2, 3], Vec.new())
    v2 = Vec.from_list([1, 2, 3])
    v3 = Enum.into([:a, :b, :c], Vec.new())
    # TODO: this requires Enumerable.Vec.reduce/3 to be implemented to work
    # v4 = Enum.into(v1, v2)

    assert Vec.equals?(v1, v1)
    assert Vec.equals?(v2, v2)
    assert Vec.equals?(v1, v2)
    refute Vec.equals?(v1, v3)
    refute Vec.equals?(v2, v3)

    assert Vec.equals?(
             Enum.into([1, 2, 3], v2),
             Enum.into([1, 2, 3], v1)
           )
  end
end

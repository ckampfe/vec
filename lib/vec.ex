defmodule Vec do
  use Rustler, otp_app: :vec, crate: :vec

  defstruct [:repr]

  defmacrop nif_error() do
    quote do
      :erlang.nif_error(:nif_not_loaded)
    end
  end

  # public API
  def new(), do: %__MODULE__{repr: new_impl()}
  def with_capacity(capacity), do: %__MODULE__{repr: with_capacity_impl(capacity)}
  def count(this), do: count_impl(this.repr)
  def capacity(this), do: capacity_impl(this.repr)
  def push(this, element), do: %__MODULE__{repr: push_impl(this.repr, element)}
  def at(this, index, default \\ nil), do: at_impl(this.repr, index, default)
  def set_at(this, index, element), do: %__MODULE__{repr: set_at_impl(this.repr, index, element)}
  def member?(this, element), do: is_member_impl(this.repr, element)
  def clear(this), do: %__MODULE__{repr: clear_impl(this.repr)}
  def empty?(this), do: empty_impl?(this)
  def last(this, default \\ nil), do: last_impl(this.repr, default)
  def to_list(this), do: to_list_impl(this.repr)
  def from_list(list), do: %__MODULE__{repr: from_list_impl(list)}
  def remove(this, index), do: %__MODULE__{repr: remove_impl(this, index)}

  def equals?(left, right) do
    to_list_impl(left.repr) == to_list_impl(right.repr)
  end

  defp new_impl(), do: nif_error()
  defp with_capacity_impl(_capacity), do: nif_error()
  defp count_impl(_this), do: nif_error()
  defp capacity_impl(_this), do: nif_error()
  defp push_impl(_this, _element), do: nif_error()
  defp at_impl(_this, _index, _default), do: nif_error()
  defp set_at_impl(_this, _index, _element), do: nif_error()
  defp is_member_impl(_this, _element), do: nif_error()
  defp clear_impl(_this), do: nif_error()
  defp empty_impl?(this), do: count(this) == 0
  defp last_impl(_this, _default), do: nif_error()
  defp to_list_impl(_this), do: nif_error()
  defp from_list_impl(_list), do: nif_error()
  defp remove_impl(_this, _index), do: nif_error()
end

defimpl Enumerable, for: Vec do
  # TODO
  # def reduce(_list, {:halt, acc}, _fun), do: {:halted, acc}
  # def reduce(list, {:suspend, acc}, fun), do: {:suspended, acc, &reduce(list, &1, fun)}
  # def reduce([], {:cont, acc}, _fun), do: {:done, acc}
  # def reduce([head | tail], {:cont, acc}, fun), do: reduce(tail, fun.(head, acc), fun)

  def reduce(_vec, {:halt, acc}, _fun), do: {:halted, acc}
  def reduce(vec, {:suspend, acc}, fun), do: {:suspended, acc, &reduce(vec, &1, fun)}

  def reduce(vec, {:cont, acc}, fun) do
    if Vec.empty?(vec) do
      {:done, acc}
    else
      head = Vec.at(vec, 0)
      tail = Vec.remove(vec, 0)
      reduce(tail, fun.(head, acc), fun)
    end
  end

  def count(enumerable) do
    Vec.count(enumerable)
  end

  def member?(enumerable, element) do
    Vec.member?(enumerable, element)
  end

  # TODO
  # def slice(enumerable)
end

defimpl Collectable, for: Vec do
  def into(vec) do
    collector_fun = fn
      vec_acc, {:cont, elem} ->
        Vec.push(vec_acc, elem)

      vec_acc, :done ->
        vec_acc

      _vec_acc, :halt ->
        :ok
    end

    initial_acc = vec

    {initial_acc, collector_fun}
  end
end

defimpl Inspect, for: Vec do
  def inspect(vec, opts) do
    Inspect.Algebra.concat(["#Vec<", Inspect.Algebra.to_doc(Vec.to_list(vec), opts), ">"])
  end
end

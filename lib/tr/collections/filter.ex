defmodule Tr.Collections.Filter do
  @moduledoc """
  Module to build dynamic query based at passed filter arguments
  """

  import Ecto.Query

  @type t :: {:ok, %Ecto.Query.DynamicExpr{}} | {:error, :unprocessable_query}

  @spec build(map(), [atom()]) :: t()
  def build(params, allowed_fields \\ []) do
    params
    |> Enum.filter(fn {field, _} -> Enum.member?(allowed_fields, field) end)
    |> Enum.reduce_while({:ok, true}, fn {key, value}, {:ok, acc} ->
      case filter(key, value, acc) do
        {:ok, dynamic} -> {:cont, {:ok, dynamic}}
        {:error, reason} -> {:halt, {:error, reason}}
      end
    end)
  end

  defp filter(key, "nil", acc) do
    {:ok, dynamic([m], ^acc and is_nil(field(m, ^key)))}
  end

  defp filter(key, "null", acc) do
    {:ok, dynamic([m], ^acc and is_nil(field(m, ^key)))}
  end

  defp filter(key, value, acc) when is_binary(value) do
    {:ok, dynamic([m], ^acc and field(m, ^key) == ^value)}
  end

  defp filter(key, value, acc) when is_number(value) do
    {:ok, dynamic([m], ^acc and field(m, ^key) == ^value)}
  end

  defp filter(key, value, acc) when is_boolean(value) do
    {:ok, dynamic([m], ^acc and field(m, ^key) == ^value)}
  end

  defp filter(key, value, acc) when is_atom(value) do
    {:ok, dynamic([m], ^acc and field(m, ^key) == ^value)}
  end

  defp filter(key, value, acc) when is_list(value) do
    {:ok, dynamic([m], ^acc and field(m, ^key) in ^value)}
  end

  defp filter(key, value, acc) when is_map(value) do
    Enum.reduce_while(value, {:ok, acc}, fn {c_key, c_value}, {:ok, c_acc} ->
      case apply_comparison(c_key, c_value, key, c_acc) do
        {:ok, result} -> {:cont, {:ok, result}}
        {:error, reason} -> {:halt, {:error, reason}}
      end
    end)
  end

  defp apply_comparison("gt", comparison_value, key, acc) do
    {:ok, dynamic([m], ^acc and field(m, ^key) > ^comparison_value)}
  end

  defp apply_comparison(:gt, comparison_value, key, acc) do
    {:ok, dynamic([m], ^acc and field(m, ^key) > ^comparison_value)}
  end

  defp apply_comparison("gte", comparison_value, key, acc) do
    {:ok, dynamic([m], ^acc and field(m, ^key) >= ^comparison_value)}
  end

  defp apply_comparison(:gte, comparison_value, key, acc) do
    {:ok, dynamic([m], ^acc and field(m, ^key) >= ^comparison_value)}
  end

  defp apply_comparison("lt", comparison_value, key, acc) do
    {:ok, dynamic([m], ^acc and field(m, ^key) < ^comparison_value)}
  end

  defp apply_comparison(:lt, comparison_value, key, acc) do
    {:ok, dynamic([m], ^acc and field(m, ^key) < ^comparison_value)}
  end

  defp apply_comparison("lte", comparison_value, key, acc) do
    {:ok, dynamic([m], ^acc and field(m, ^key) <= ^comparison_value)}
  end

  defp apply_comparison(:lte, comparison_value, key, acc) do
    {:ok, dynamic([m], ^acc and field(m, ^key) <= ^comparison_value)}
  end

  defp apply_comparison("eq", comparison_value, key, acc) do
    {:ok, dynamic([m], ^acc and field(m, ^key) == ^comparison_value)}
  end

  defp apply_comparison(:eq, comparison_value, key, acc) do
    {:ok, dynamic([m], ^acc and field(m, ^key) == ^comparison_value)}
  end

  defp apply_comparison("not", "nil", key, acc) do
    {:ok, dynamic([m], ^acc and not is_nil(field(m, ^key)))}
  end

  defp apply_comparison(:not, "nil", key, acc) do
    {:ok, dynamic([m], ^acc and not is_nil(field(m, ^key)))}
  end

  defp apply_comparison("not", "null", key, acc) do
    {:ok, dynamic([m], ^acc and not is_nil(field(m, ^key)))}
  end

  defp apply_comparison(:not, "null", key, acc) do
    {:ok, dynamic([m], ^acc and not is_nil(field(m, ^key)))}
  end

  defp apply_comparison("not", comparison_value, key, acc) do
    {:ok, dynamic([m], ^acc and not (field(m, ^key) == ^comparison_value))}
  end

  defp apply_comparison(:not, comparison_value, key, acc) do
    {:ok, dynamic([m], ^acc and not (field(m, ^key) == ^comparison_value))}
  end

  defp apply_comparison("has", comparison_value, key, acc) do
    {:ok, dynamic([m], ^acc and ilike(field(m, ^key), ^"%#{comparison_value}%"))}
  end

  defp apply_comparison(:has, comparison_value, key, acc) do
    {:ok, dynamic([m], ^acc and ilike(field(m, ^key), ^"%#{comparison_value}%"))}
  end

  defp apply_comparison(_, _comparison_value, _key, _acc) do
    {:error, :unprocessable_query}
  end
end

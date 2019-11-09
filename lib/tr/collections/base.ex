defmodule Tr.Collections.Base do
  @doc false
  defmacro __using__(_opts) do
    quote do
      import unquote(__MODULE__)
      Module.register_attribute(__MODULE__, :model, accumulate: false, persist: true)

      require Ecto.Query
      alias Ecto.Query
      alias Tr.Repo
      alias Tr.Collections.Filter

      def create(attrs) do
        with {:ok, model} <-
               @model.__struct__
               |> @model.changeset(attrs)
               |> Repo.insert() do
          {:ok, model}
        else
          {:error, reason} -> {:error, reason}
        end
      end

      def create_all(entries) do
        entries
        |> Enum.chunk_every(10_000)
        |> Enum.each(
          &Repo.insert_all(@model, &1,
            on_conflict: :replace_all,
            conflict_target: [:id]
          )
        )
      end

      def update(model, attrs) do
        with {:ok, model} <- model |> @model.changeset(attrs) |> Repo.update() do
          {:ok, model}
        else
          {:error, reason} -> {:error, reason}
        end
      end

      def find(id) when is_integer(id) do
        with nil <- Repo.get(@model, id) do
          {:error, :not_found}
        else
          instance -> {:ok, instance |> Repo.preload(:rate_plan)}
        end
      end

      def find(_id), do: {:error, :invalid_id}

      def list(opts \\ %{}) do
        with {:ok, where} <- Filter.build(opts[:filter] || [], @model.__schema__(:fields)) do
          {
            :ok,
            @model
            |> Query.from(where: ^where)
            |> Repo.all()
            |> Repo.preload(opts[:preload] || [])
          }
        else
          {:error, reason} -> {:error, reason}
        end
      end

      @spec drop(map) :: {:ok, map} | {:error, map}
      def drop(model) do
        with {:ok, model} <- Repo.delete(model) do
          {:ok, model}
        else
          {:error, reason} -> {:error, reason}
        end
      end

      @spec drop_all() :: {integer, nil} | {:error, atom}
      def drop_all do
        with {i, _} when is_integer(i) <- Repo.delete_all(@model) do
          {:ok, i}
        else
          error -> error
        end
      end
    end
  end
end

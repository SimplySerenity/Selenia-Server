defmodule Pools.Duplicates do
	alias Ets.Set.KeyValueSet, as: KVSet

	use ExActor.GenServer, export: __MODULE__

	defstart start_link(_args), do: initial_state(KVSet.new!(name: :duplicate_links)), export: __MODULE__

	defcall push(link), state: state do
		state
		|> KVSet.put_new!(link, true)
		|> new_state

		reply(:ok)
	end

	defcall exists?(link), state: state do
		reply(
			state |> KVSet.has_key!(link)
		)
	end
end
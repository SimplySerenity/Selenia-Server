defmodule Pools.Pool do
	alias Ets.Set, as: Set

	use ExActor.GenServer, export: __MODULE__
	require Logger

	defstart start_link(_args), do: initial_state(Set.new!(name: :link_pools)), export: __MODULE__

	# creates an empty pool
	defcast create(pool_name), state: state do
		state
		|> Set.put_new!({pool_name, Qex.new})
		|> new_state
	end

	# creates a pool with some initial data
	defcast create(pool_name, links), state: state do
		Enum.each(links, fn link -> Pools.Duplicates.push(link) end)

		state
		|> Set.put_new!({pool_name, Qex.new(links)})
		|> new_state
	end

	# pushs links to the pool
	defcast push(pool_name, links), state: state do
		case state |> Set.get_element(pool_name, 2) do
			{:ok, queue} ->
				links = Enum.filter(links, fn link ->
					!Pools.Duplicates.exists?(link)
				end)

				Enum.each(links, fn link -> Pools.Duplicates.push(link) end)

				state 
				|> Set.put!({pool_name, Enum.into(links, queue)})
				|> new_state
			{:error, _} ->
				Logger.info "Failed to push to pool #{pool_name}"
		end
	end

	# returns the first link in the pool
	defcall get(pool_name), state: state do
		case state |> Set.get_element(pool_name, 2) do
			{:ok, queue} ->
				case Qex.pop(queue) do
					{{:value, item}, queue} ->
						state
						|> Set.put!({pool_name, queue})
						|> new_state

						reply({:ok, item})
					{:empty, _} ->
						reply({:empty})
				end
			{:error, msg} ->
				reply({:error, msg})
		end
	end
end
defmodule Pools.Pool do
	use GenServer

	def start_link(opts \\ []) do
		GenServer.start_link(__MODULE__, %{}, opts)
	end

	# Nice methods that wrap GenServer calls

	# Attempts to create an empty pool
	# fails if the pool already exists
	def create(pool_name) do
		GenServer.call(__MODULE__, {:create, pool_name, []})
	end

	# Attempts to create a new pool with the given links
	# returns :ok on success or :error if the pool already exists
	def create(pool_name, links) do
		GenServer.call(__MODULE__, {:create, pool_name, links}) 
	end

	# Attepts to push the given links to the pool
	# returns :ok for success and :error if the pool doesn't exist
	def push(pool_name, links) do
		GenServer.call(__MODULE__, {:push, pool_name, links})
	end

	def get(pool_name) do
		GenServer.call(__MODULE__, {:get, pool_name})
	end

	# GenServer callbacks

	def handle_call({:create, pool_name, links}, _from, state) do
		case Map.has_key?(state, pool_name) do
			false -> {:reply, :ok, Map.put(state, pool_name, :queue.from_list(links))}
			true -> {:reply, :error, state}
		end
	end

	def handle_call({:push, pool_name, links}, _from, state) do
		case Map.get(state, pool_name) do
			nil -> {:reply, :error, state}
			queue -> {:reply, :ok, Map.put(state, pool_name, :queue.join(queue, :queue.from_list(links)))}
		end
	end

	def handle_call({:get, pool_name}, _from, state) do
		case Map.get(state, pool_name) do
			nil -> {:reply, {:error}, state}
			queue ->
				if :queue.is_empty(queue) do
					{:reply, {:empty}, state}
				else
					{:reply, :queue.out(queue), Map.put(state, pool_name, :queue.drop(queue))}
				end
		end
	end
end
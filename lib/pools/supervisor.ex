defmodule Pools.Supervisor do
	use Supervisor

	def start_link do
		Supervisor.start_link(__MODULE__, [], name: __MODULE__)
	end

	def init(_state) do
		children = [
			worker(Pools.Pool, [[name: Pools.Pool]]),
			worker(Pools.Duplicates, [[name: Pools.Duplicates]])
		]

		supervise(children, strategy: :one_for_one)
	end
end
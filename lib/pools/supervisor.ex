defmodule Pools.Supervisor do
	use Supervisor

	def start_link do
		Supervisor.start_link(__MODULE__, [], name: __MODULE__)
	end

	def init(state) do
		children = [
			worker(Pools.Pool, [[name: Pools.Pool]])
		]

		supervise(children, strategy: :one_for_one)
	end
end
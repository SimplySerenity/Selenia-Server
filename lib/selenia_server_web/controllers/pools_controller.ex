defmodule SeleniaServerWeb.PoolsController do
	use SeleniaServerWeb, :controller

	# creates a new pool(queue) that's wrapped up with GenServer
	def new(conn, params) do
		case params["links"] do
			nil -> 
				Pools.Pool.create(params["pool_name"])
			links ->
				Pools.Pool.create(params["pool_name"], links)
		end

		conn
		|> send_resp(204, "")
	end

	def push(conn, params) do
		if params["links"] == nil do
			conn
			|> put_status(400)
			|> render("error.json", error: "Please specify the links you want to push to the pool.")
		else
			Pools.Pool.push(params["pool_name"], params["links"])

			conn
			|> send_resp(204, "")
		end
	end

	def fetch(conn, params) do
		case Pools.Pool.get(params["pool_name"]) do
			{:ok, link} ->
				conn
				|> render("fetch.json", link: link)
			{:empty} ->
				conn
				|> render("error.json", error: "That pool is currently empty.")
			{:error, msg} ->
				conn
				|> put_status(500)
				|> render("error.json", error: msg)
		end
	end
end
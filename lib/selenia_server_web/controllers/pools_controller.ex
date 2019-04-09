defmodule SeleniaServerWeb.PoolsController do
	use SeleniaServerWeb, :controller

	# creates a new pool(queue) that's wrapped up with GenServer
	def new(conn, params) do
		case params["links"] do
			nil -> 
				case Pools.Pool.create(params["pool_name"]) do
					:error -> 
						conn 
						|> send_resp(200, "")
					:ok ->
						conn
						|> send_resp(201, "")
				end
			links ->
				case Pools.Pool.create(params["pool_name"], links) do
					:error -> 
						conn 
						|> send_resp(200, "")
					:ok ->
						conn
						|> send_resp(201, "")
				end
		end
	end

	def push(conn, params) do
		if params["links"] == nil do
			conn
			|> put_status(400)
			|> render("error.json", error: "Please specify the links you want to push to the pool.")
		else
			case Pools.Pool.push(params["pool_name"], params["links"]) do
				:error -> 
					conn
					|> put_status(400)
					|> render("error.json", error: "That pool doesn't exist.")
				:ok ->
					conn
					|> send_resp(200, "")
			end
		end
	end

	def fetch(conn, params) do
		case Pools.Pool.get(params["pool_name"]) do
			{{:value, link}, _queue} ->
				conn
				|> render("fetch.json", link: link)
			{:empty} ->
				conn
				|> render("error.json", error: "That pool is currently empty.")
			{:error} ->
				conn
				|> put_status(400)
				|> render("error.json", error: "That pool doesn't exist.")
		end
	end
end
defmodule SeleniaServerWeb.PoolsController do
	use SeleniaServerWeb, :controller

	def push(conn, params) do
		conn
		|> render("push.json", data: params)
	end
end
defmodule SeleniaServerWeb.PoolsView do
	use SeleniaServerWeb, :view

	def render("push.json", %{data: data}) do
		data
	end
end
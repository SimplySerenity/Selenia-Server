defmodule SeleniaServerWeb.PoolsView do
	use SeleniaServerWeb, :view

	def render("fetch.json", %{link: link}) do
		%{
			link: link
		}
	end

	def render("error.json", %{error: error}) do
		%{
			error: error
		}	
	end
end
defmodule SeleniaServerWeb.Router do
  use SeleniaServerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", SeleniaServerWeb do
    pipe_through :api

    post "/pools/:pool_name", PoolsController, :new
    post "/pools/:pool_name/links", PoolsController, :push
    get "/pools/:pool_name/links", PoolsController, :fetch
  end
end

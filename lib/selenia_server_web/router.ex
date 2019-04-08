defmodule SeleniaServerWeb.Router do
  use SeleniaServerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", SeleniaServerWeb do
    pipe_through :api
    post "/pools/push", PoolsController, :push
  end
end

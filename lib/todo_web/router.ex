defmodule TodoWeb.Router do
  use TodoWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug TodoWeb.Plugs.Auth
  end

  scope "/api", TodoWeb do
    pipe_through :api
    post "/users", UserController, :register
    post "/users/sign_in", UserController, :sign_in

    pipe_through :auth
    post "/tasks", TaskController, :create_task
    get "/tasks", TaskController, :list_tasks
    get "/tasks/:id", TaskController, :get_task
    put "/tasks/:id", TaskController, :update_task
    delete "/tasks/:id", TaskController, :delete_task
    put "/tasks/:id/reposition", TaskController, :reposition_task
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:todo, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: TodoWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end

defmodule Bugoverflow do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Bugoverflow.Repo, []),
      # Start the endpoint when the application starts
      supervisor(Bugoverflow.Endpoint, []),
      # Start your own worker by calling: Bugoverflow.Worker.start_link(arg1, arg2, arg3)
      # worker(Bugoverflow.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Bugoverflow.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Bugoverflow.Endpoint.config_change(changed, removed)
    :ok
  end
end

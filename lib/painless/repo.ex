defmodule Painless.Repo do
  use Ecto.Repo,
    otp_app: :painless,
    adapter: Ecto.Adapters.Postgres
end

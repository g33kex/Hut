defmodule Hut.Repo do
  use Ecto.Repo,
    otp_app: :hut,
    adapter: Ecto.Adapters.SQLite3
end

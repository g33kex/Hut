defmodule Hut.BookingSchema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bookings" do
    field :user_id, Ecto.UUID
    field :name, :string
    field :date, :date
    field :period, Ecto.Enum, values: [:lunch, :dinner]

    timestamps()
  end

  def changeset(booking, attrs) do
    booking
    |> cast(attrs, [:user_id, :name, :date, :period])
    |> validate_required([:user_id, :name, :date, :period])
    |> unique_constraint(:date)
  end
end

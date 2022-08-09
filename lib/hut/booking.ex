defmodule Hut.Booking do
  use GenServer

  alias Hut.BookingSchema
  alias Hut.Repo
  alias Ecto.Changeset

  import Ecto.Query

  def book(user_id, name, date, period) do
    changeset = BookingSchema.changeset(%BookingSchema{}, %{user_id: user_id, name: name, date: date, period: period})

    IO.inspect(changeset, label: "BOOK")
    if changeset.valid? do
      Repo.insert(changeset)
    end
  end

  def cancel(user_id, date, period) do
    BookingSchema |> Repo.get_by(user_id: user_id, date: date, period: period) |> Repo.delete()
  end 

  def get_bookings(date) do
    query = from b in BookingSchema,
         where: b.date == ^date,
         select: {b.name, b.period}
    Repo.all(query) |> Enum.map(fn {k,v}->{v,k} end) |> Map.new
  end

end

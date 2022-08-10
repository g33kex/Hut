defmodule Hut.Booking do
  alias Hut.BookingSchema
  alias Hut.Repo
  alias Ecto.Changeset

  import Ecto.Query

  def book(user_id, name, date, period) do
    changeset = BookingSchema.changeset(%BookingSchema{}, %{user_id: user_id, name: name, date: date, period: period})

    if changeset.valid? do
      Repo.insert(changeset)
    end
  end

  def cancel(user_id, date, period) do
    if date >= Timex.today() do
      BookingSchema |> Repo.get_by(user_id: user_id, date: date, period: period) |> Repo.delete()
    end
  end 

  def get_bookings(date) do
    query = from b in BookingSchema,
         where: b.date == ^date,
         select: {b.period, b.name, b.user_id}
    Repo.all(query) |> Enum.map(fn {period, name, user_id}->{period,%{name: name, user_id: user_id}} end) |> Map.new 
  end

end

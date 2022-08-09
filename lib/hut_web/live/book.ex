defmodule HutWeb.Book do
  use Phoenix.LiveView
  use Timex

  alias HutWeb.BookView
  alias Hut.Booking

  def mount(%{"date" => sdate}, %{"user_id" => user_id}, socket) do
    date = Timex.parse!(sdate, "{YYYY}-{M}-{D}") |> Timex.to_date
    bookings = Booking.get_bookings(date)
    HutWeb.Endpoint.subscribe(topic(date))

    {:ok, assign(socket, date: date, bookings: bookings, user_id: user_id)}
  end

 def handle_event("save", %{"lunch" => %{"name" => name}}, socket) do
    Booking.book(socket.assigns.user_id, name, socket.assigns.date, "lunch")

    bookings = Booking.get_bookings(socket.assigns.date)
    new_state = assign(socket, :bookings, bookings)
    HutWeb.Endpoint.broadcast(topic(socket.assigns.date), "booking:updated", new_state.assigns)

    {:noreply, new_state}
  end

  def handle_event("save", %{"dinner" => %{"name" => name}}, socket) do
    Booking.book(socket.assigns.user_id, name, socket.assigns.date, "dinner")

    bookings = Booking.get_bookings(socket.assigns.date)
    new_state = assign(socket, :bookings, bookings)
    HutWeb.Endpoint.broadcast(topic(socket.assigns.date), "booking:updated", new_state.assigns)

    {:noreply, new_state}
  end

  def handle_event("cancel", %{"period" => period}, socket) do
    Booking.cancel(socket.assigns.user_id, socket.assigns.date, period)

    bookings = Booking.get_bookings(socket.assigns.date)
    new_state = assign(socket, :bookings, bookings)
    HutWeb.Endpoint.broadcast(topic(socket.assigns.date), "booking:updated", new_state.assigns)

    {:noreply, new_state}
  end

  def handle_info(%{topic: topic, event: "booking:updated", payload: new_state}, socket) do
    IO.inspect(topic, label: "HANDLE EVENT")
    if topic(socket.assigns.date) == topic do
        {:noreply, assign(socket, bookings: new_state.bookings)}
    else
        {:noreply, socket}
    end
  end

  def render(assigns) do
    BookView.render("index.html", assigns)
  end

  defp topic(date) do
    "date:#{Timex.format!(date, "{YYYY}-{M}-{D}")}"
  end

end




defmodule HutWeb.Booking do
  use Phoenix.LiveView
  use Timex

  alias HutWeb.BookingView

  def mount(_params, _session, socket) do
    {:ok, assign(socket, date: Timex.today())}
  end

  def handle_event("save", %{"lunch" => %{"name" => name}}, socket) do
    IO.inspect(name, label: "SAVE EVENT LUNCH")
    {:noreply, socket}
  end

  def handle_event("save", %{"dinner" => %{"name" => name}}, socket) do
    IO.inspect(name, label: "SAVE EVENT DINNER")
    {:noreply, socket}
  end

  def render(assigns) do
    BookingView.render("index.html", assigns)
  end

end




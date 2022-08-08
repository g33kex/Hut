defmodule HutWeb.Calendar do
  use Phoenix.LiveView
  use Timex

  alias HutWeb.CalendarView
  alias HutWeb.Booking

  def mount(_params, _session, socket) do
    current_date = Timex.today()

    {:ok, assign(socket, current_date: current_date, day_names: day_names(), week_rows: week_rows(current_date))}
  end

  def handle_event("prev-month", _, socket) do
    current_date = Timex.shift(socket.assigns.current_date, months: -1)
    {:noreply, assign(socket, current_date: current_date, day_names: day_names(), week_rows: week_rows(current_date))}
  end

  def handle_event("next-month", _, socket) do
    current_date = Timex.shift(socket.assigns.current_date, months: +1)
    {:noreply, assign(socket, current_date: current_date, day_names: day_names(), week_rows: week_rows(current_date))}
  end

  #def handle_event("book", _, socket) do
  #  {:noreply, push_patch(socket, to: Routes.live_path(socket, Booking))}
  #end

  def handle_info({:updated_date, updated_date}, socket) do
    {:noreply, assign(socket, current_date: updated_date)}
  end

  def render(assigns) do
    CalendarView.render("index.html", assigns)
  end

  def day_names() do
    Enum.map([1, 2, 3, 4, 5, 6, 7], &Timex.day_name/1)
  end

  def day_shortnames() do
    Enum.map([1, 2, 3, 4, 5, 6, 7], &Timex.day_shortname/1)
  end

  defp week_rows(current_date) do
    first = current_date |> Timex.beginning_of_month |> Timex.beginning_of_week
    last = current_date |> Timex.end_of_month |> Timex.end_of_week

    Interval.new(from: first, until: last, left_open: false, right_open: false) |> Enum.map(&(Timex.to_date(&1))) |> Enum.chunk_every(7)
  end
  
end




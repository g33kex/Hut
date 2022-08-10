defmodule HutWeb.CalendarDayComponent do
  use Phoenix.LiveComponent
  use Timex

  alias HutWeb.CalendarView
  alias Hut.Booking

  def update(assigns, socket) do
    day = assigns.id
    bookings = Booking.get_bookings(day)
    HutWeb.Endpoint.subscribe(topic(day))
    {:ok, assign(socket, day: day, current_date: assigns.current_date, bookings: bookings, user_id: assigns.user_id)}
  end

  def handle_event("pick-date", _, socket) do
    send(self(), {:updated_date, socket.assigns.day})
    {:noreply, socket}
  end

  def handle_info(%{topic: topic, event: "booking:updated", payload: new_state}, socket) do
    if topic(socket.assigns.date) == topic do
        {:noreply, assign(socket, bookings: new_state.bookings)}
    else
        {:noreply, socket}
    end
  end

  def render(assigns) do
    ~H"""
    <td>
      <div class="grid grid-cols-5 grid-rows-2 place-items-center m-1 sm:m-3 justify-items-start">
        <button disabled={other_month?(@day, @current_date)} phx-click="pick-date" phx-target={@myself}  class={ "col-span-4 row-span-2 w-10 h-10 rounded-full whitespace-nowrap text-sm "<>day_class(@day, @current_date)}>
          <%= Timex.format!(@day, "%d", :strftime) %>
        </button>
        <%= if not other_month?(@day, @current_date) do %>
        <span class={ "w-2 h-2 rounded-full "<>indicator_class(@day, :lunch, @bookings, @user_id)}></span>
        <span class={ "w-2 h-2 rounded-full "<>indicator_class(@day, :dinner, @bookings, @user_id)}></span>
        <% end %>
      </div>
    </td>
    """
  end

  defp indicator_class(day, period, bookings, user_id) do
    cond do
      period == :lunch and Map.has_key?(bookings, :lunch) ->
        if bookings.lunch.user_id == user_id do
          "bg-sky-400"
        else
          "bg-pink-400"
        end
      period == :dinner and Map.has_key?(bookings, :dinner) ->
        if bookings.dinner.user_id == user_id do
          "bg-sky-400"
        else
          "bg-pink-400"
        end
      true ->
        "bg-transparent"
    end
  end

  defp day_class(day, current_date) do
    cond do
      day == Timex.today() ->
        "text-gray-900 bg-green-200 hover:bg-green-300 cursor-pointer"
      day == current_date ->
        "text-gray-900 bg-blue-100 cursor-pointer"
      other_month?(day, current_date) ->
        "text-gray-300 bg-white cursor-default"
      true ->
        "text-gray-900 bg-white hover:bg-blue-100 cursor-pointer"
    end
  end

  defp other_month?(day, current_date) do
    {day.year, day.month} != {current_date.year, current_date.month}
  end

  defp topic(date) do
    "date:#{Timex.format!(date, "{YYYY}-{M}-{D}")}"
  end
end

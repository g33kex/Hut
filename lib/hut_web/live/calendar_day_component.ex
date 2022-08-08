defmodule HutWeb.CalendarDayComponent do
  use Phoenix.LiveComponent
  use Timex

  alias HutWeb.CalendarView

  def update(assigns, socket) do
    day = assigns.id
    {:ok, assign(socket, day: day, current_date: assigns.current_date)}
  end

  def handle_event("pick-date", _, socket) do
    send(self(), {:updated_date, socket.assigns.day})
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <td>
      <button disabled={other_month?(@day, @current_date)} phx-click="pick-date" phx-target={@myself}  class={"w-10 h-10 m-1 sm:m-4 rounded-full whitespace-nowrap text-sm "<>day_class(@day, @current_date)}>
        <%= Timex.format!(@day, "%d", :strftime) %>
      </button>
    </td>
    """
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
end

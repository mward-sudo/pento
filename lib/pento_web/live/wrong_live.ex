defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  @new_game_msg "Guess a number."

  def mount(_params, _session, socket) do
    {
      :ok,
      assign(
        socket,
        correct_answer: generate_random_answer(),
        score: 0,
        message: @new_game_msg,
        correct_guess: false
      )
    }
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    case socket.assigns.correct_answer |> to_string do
      ^guess ->
        {
          :noreply,
          assign(
            socket,
            message: "Your guess: #{guess}. You got it right!",
            score: socket.assigns.score + 5,
            correct_guess: true
          )
        }

      _ ->
        {
          :noreply,
          assign(
            socket,
            message: "Your guess: #{guess}. Wrong. Guess again.",
            score: socket.assigns.score - 1
          )
        }
    end
  end

  def handle_params(%{"new_game" => "true"}, _url, socket) do
    {
      :noreply,
      assign(
        socket,
        correct_answer: generate_random_answer(),
        correct_guess: false,
        message: @new_game_msg
      )
    }
  end

  def render(assigns) do
    ~L"""
    <h1>Your score: <%= @score %></h1>
    <h2>
      <%= @message %>
    </h2>
    <%= if @correct_guess do %>
      <p style="font-size: 3rem;">
        <%= live_patch "Guess another number", to: Routes.live_path(@socket, PentoWeb.WrongLive, %{new_game: true}) %>
      </p>
    <% else %>
      <h2>
        <%= for n <- 1..10 do %>
          <a href="#" phx-click="guess" phx-value-number="<%= n %>"><%= n %></a>
        <% end %>
      </h2>
    <% end %>
    """
  end

  def generate_random_answer() do
    1..10 |> Enum.random()
  end
end

defmodule Hangman.Game do

  defstruct(
    turns_left: 7,
    game_state: :init,
    letters: [],
    guessed_letters: MapSet.new()
  )
  def init_game() do
    %Hangman.Game{
      letters: Dictionary.random_word() |> String.codepoints()
    }
  end

  def make_move(game = %{ game_state: state }, _guess) when state in [:won, :lost] do
    { game, tally(game)}
  end

  def make_move(game, guess) do
    accept_move(game, guess, game.guessed_letters |> MapSet.member?(guess))
  end

  def accept_move(game, _guess, _letter_already_guessed = true) do
    game
    |> Map.put(:game_state, :letter_already_guessed)
  end

  def accept_move(game, guess, _letter_not_guessed) do
    game
    |> Map.put(:guessed_letters, MapSet.put(game.guessed_letters, guess))
    |> process_guess(Enum.member?(game.letters, guess))

  end

  def process_guess(game, _good_guess = true) do
    game.letters
    |> MapSet.new()
    |> MapSet.subset?(game.guessed_letters)
    |> win_conditions()
  end

  def process_guess(game, _bad_guess) do
    game_with_less_turns = Map.put(game, :turns_left, game.turns_left - 1)
    Map.put(game_with_less_turns, :game_state, lose_conditions(game_with_less_turns))
  end

  def win_conditions(_game_won = true), do: :won

  def win_conditions(_game_not_won), do: :good_guess

  # def lose_conditions(game = %{ turns_left = turns }) when turns = 0 do
  #   :lost
  # end

  def lose_conditions(_), do: :bad_guess

  def tally(_game) do
    1234
  end

end

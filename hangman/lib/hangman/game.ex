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
    |> Map.put(:turns_left, game.turns_left - 1)
  end

  # def accept_move(game, guess, _letter_not_guessed) do
  #   game |> Map.put(:guessed_letters, MapSet.put(game, value))
  # end

  def tally(_game) do
    1234
  end

end

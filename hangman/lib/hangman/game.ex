defmodule Hangman.Game do

  defstruct(
    turns_left: 7,
    game_state: :init,
    letters: [],
    guessed_letters: MapSet.new()
  )

  def init_game(word) do
    %Hangman.Game{
      letters: word |> String.codepoints()
    }
  end

  def init_game() do
    %Hangman.Game{
      letters: Dictionary.random_word() |> String.codepoints()
    }
  end

  def make_move(game = %{ game_state: state }, _guess) when state in [:won, :lost], do: game

  def make_move(game, guess) do
    accept_move(game, guess, game.guessed_letters |> MapSet.member?(guess))
  end

  def obfuscate(game) do
    %{
      game_state: game.game_state,
      turns_left: game.turns_left,
      letters: game |> hide_letters()
    }
  end

  ##################### private def ###########################################
  defp accept_move(game, _guess, _letter_already_guessed = true) do
    game
    |> Map.put(:game_state, :letter_already_guessed)
  end

  defp accept_move(game, guess, _letter_not_guessed) do
    game
    |> Map.put(:guessed_letters, MapSet.put(game.guessed_letters, guess))
    |> process_guess(Enum.member?(game.letters, guess))
  end

  defp process_guess(game, _good_guess = true) do
    new_state = game.letters
    |> MapSet.new()
    |> MapSet.subset?(game.guessed_letters)
    |> win_conditions()

    Map.put(game, :game_state, new_state)
  end

  defp process_guess(game = %{ turns_left: turns_left }, _bad_guess) do
    game_with_less_turns = Map.put(game, :turns_left, turns_left - 1)
    Map.put(game_with_less_turns, :game_state, lose_conditions(game_with_less_turns))
  end

  defp win_conditions(_game_won = true), do: :won

  defp win_conditions(_game_not_won), do: :good_guess

  defp lose_conditions(_game = %{ turns_left: 0 }), do: :lost

  defp lose_conditions(_), do: :bad_guess


  defp hide_letters(game) do
    Enum.map(game.letters, &(already_guessed_letter(&1, MapSet.member?(game.guessed_letters, &1))))
  end

  defp already_guessed_letter(letter, _already_guessed = true), do: letter
  defp already_guessed_letter(_letter, _not_guessed), do: "_"

end

defmodule MakeMoveTest do
  use ExUnit.Case
  doctest Hangman

  test "prevent making any moves to an already :won or :loss state" do
    for state <- [:won, :lost] do
      game = Hangman.new_game() |> Map.put(:game_state, state)
      assert {^game, _} = Hangman.make_move(game, "x")
    end
  end

  test "adding a new bad letter to the guessed letter" do
    game = Hangman.new_game()
    guess = find_bad_letter(game)
    modified_game = Hangman.make_move(game, guess)
    assert modified_game.guessed_letters |> MapSet.member?(guess) == true
    assert modified_game.turns_left == 6
  end

  test "adding a new good letter to the guessed letter" do
    game = Hangman.new_game()
    guess = find_good_letter(game)
    modified_game = Hangman.make_move(game, guess)
    assert modified_game.guessed_letters |> MapSet.member?(guess) == true
    assert modified_game.turns_left == 7
    assert modified_game.game_state == :good_guess
  end

  test "good guess until victory" do
    game = Hangman.new_game()

    finalGame = Enum.reduce(game.letters, game, fn guess, game ->
      temporaryGame = Hangman.make_move(game, guess)
      assert temporaryGame.turns_left == 7
      assert MapSet.member?(temporaryGame.guessed_letters, guess) == true
      temporaryGame
    end)

    # for guess <- game.letters do
    #   game = Hangman.make_move(game, guess)
    #   assert game.turns_left == 7
    #   assert MapSet.member?(game.guessed_letters, guess) == true
    # end

    assert finalGame.game_state == :won
  end

  test "changed state after guessing the same bad letter twice" do
    game = Hangman.new_game()
    guess = find_bad_letter(game)
    modified_game = game
    |> Hangman.make_move(guess)
    |> Hangman.make_move(guess)

    assert modified_game.guessed_letters |> MapSet.member?(guess) == true
    assert modified_game.game_state == :letter_already_guessed
    assert modified_game.turns_left == 6
  end

  defp find_good_letter(game), do: find_letter(fn (x) -> Enum.member?(game.letters, x) && !MapSet.member?(game.guessed_letters, x) end)
  defp find_bad_letter(game), do: find_letter(fn (x) -> !Enum.member?(game.letters, x) && !MapSet.member?(game.guessed_letters, x) end)

  defp find_letter(func) do
    ?a..?z
    |> Enum.map(&to_string([&1]))
    |> Enum.filter(&func.(&1))
    |> Enum.at(0)
  end
end

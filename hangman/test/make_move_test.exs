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
    {modified_game, _} = Hangman.make_move(game, guess)
    assert modified_game.guessed_letters |> MapSet.member?(guess) == true
    assert modified_game.turns_left == 6
  end

  test "adding a new good letter to the guessed letter" do
    game = Hangman.new_game()
    guess = find_good_letter(game)
    {modified_game, _} = Hangman.make_move(game, guess)
    assert modified_game.guessed_letters |> MapSet.member?(guess) == true
    assert modified_game.turns_left == 7
    assert modified_game.game_state == :good_guess
  end

  test "good guess until victory" do
    game = Hangman.new_game()

    final_game = Enum.reduce(game.letters, game, fn guess, game ->
      {temporary_game, _} = Hangman.make_move(game, guess)
      assert temporary_game.turns_left == 7
      assert MapSet.member?(temporary_game.guessed_letters, guess) == true
      temporary_game
    end)

    assert final_game.game_state == :won
  end

  test "bad guess until defeat" do
    game = Hangman.new_game()

    game_with_no_turn_left = Enum.reduce(6..1, game, fn attempt_left, game ->
      bad_guess = find_bad_letter(game)

        {temporary_game, _} = Hangman.make_move(game, bad_guess)
        assert temporary_game.turns_left == attempt_left
        assert temporary_game.game_state == :bad_guess
        temporary_game
    end)

    bad_guess = find_bad_letter(game_with_no_turn_left)
    {final_game, _} = Hangman.make_move(game_with_no_turn_left, bad_guess)

    assert final_game.turns_left == 0
    assert final_game.game_state == :lost
  end

  test "changed state after guessing the same bad letter twice" do
    game = Hangman.new_game()
    guess = find_bad_letter(game)
    {modified_game, _} = game
    |> Hangman.make_move(guess)
    |> elem(0)
    |> Hangman.make_move(guess)

    assert modified_game.guessed_letters |> MapSet.member?(guess) == true
    assert modified_game.game_state == :letter_already_guessed
    assert modified_game.turns_left == 6
  end

  test "validate obfuscated game" do
    obfuscated_game_letters = Hangman.new_game("word")
    |> Hangman.make_move("r")
    |> elem(1)
    letter_count_map = Enum.reduce(obfuscated_game_letters.letters, %{}, fn letter, map -> Map.put(map, letter, letter_count(letter, map) + 1) end)

    assert Map.get(letter_count_map, "_") == 3
    assert Map.get(letter_count_map, "r") == 1

  end

  defp letter_count(letter, map), do: if Map.has_key?(map, letter), do: Map.get(map, letter), else: 0

  defp find_good_letter(game), do: find_letter(fn (x) -> Enum.member?(game.letters, x) && !MapSet.member?(game.guessed_letters, x) end)
  defp find_bad_letter(game), do: find_letter(fn (x) -> !Enum.member?(game.letters, x) && !MapSet.member?(game.guessed_letters, x) end)

  defp find_letter(func) do
    ?a..?z
    |> Enum.map(&to_string([&1]))
    |> Enum.filter(&func.(&1))
    |> Enum.at(0)
  end
end

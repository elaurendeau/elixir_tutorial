defmodule MakeMoveTest do
  use ExUnit.Case
  doctest Hangman

  test "prevent making any moves to an already :won or :loss state" do
    for state <- [:won, :lost] do
      game = Hangman.new_game() |> Map.put(:game_state, state)
      assert {^game, _} = Hangman.make_move(game, "x")
    end
  end

  test "adding a new letter to the guessed letter" do
    game = Hangman.new_game() |> Hangman.make_move("p")
    assert game.guessed_letters |> MapSet.member?("p") == true
    assert game.turns_left == 6
  end

  test "changed state after guessing the same letter twice" do
    game = Hangman.new_game() |> Hangman.make_move("p") |> Hangman.make_move("p")
    assert game.guessed_letters |> MapSet.member?("p") == true
    assert game.game_state == :letter_already_guessed
    assert game.turns_left == 6
  end
end

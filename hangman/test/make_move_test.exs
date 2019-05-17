defmodule MakeMoveTest do
  use ExUnit.Case
  doctest Hangman

  test "prevent making any moves to an already :won or :loss state" do
    for state <- [:won, :lost] do
      game = Hangman.new_game() |> Map.put(:game_state, state)
      assert {^game, _} = Hangman.make_move(game, "x")
    end
  end
end

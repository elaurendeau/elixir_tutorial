defmodule NewGameTest do
  use ExUnit.Case
  doctest Hangman

  test "new_game returns a proper state" do
    state = Hangman.new_game()
    assert state.game_state == :init
    assert state.turns_left == 7
    assert state.letters |> length() > 0
  end

  test "validate that letters are lower case" do
    state = Hangman.new_game()
    assert state.letters |> List.foldl(true, &(String.downcase(&1) == &1 && &2)) == true
  end
end

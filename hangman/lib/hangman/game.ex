defmodule Hangman.Game do

  defstruct(
    turns_left: 7,
    game_state: :init,
    letters: []
  )
  def init_game() do
    %Hangman.Game{
      letters: Dictionary.random_word() |> String.codepoints()
    }
  end

  def make_move(game = %{ game_state: state }, _guess) when state in [:won, :lost] do
    { game, tally(game)}
  end

  def tally(_game) do
    1234
  end

end

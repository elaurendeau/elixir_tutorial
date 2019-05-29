defmodule Hangman do

  alias Hangman.Game

  defdelegate new_game(word), to: Game, as: :init_game
  defdelegate new_game(), to: Game, as: :init_game
  def make_move(game, guess) do
    game = Game.make_move(game, guess)
    {game, Game.obfuscate(game)}
  end
end


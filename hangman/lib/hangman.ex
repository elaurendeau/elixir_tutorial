defmodule Hangman do
  def hello do
    Dictionary.random_word()
    |> IO.puts()
  end
  
  def test do
  end
end


defmodule Dictionary do
  def hello do
    IO.puts("Hello world!")
  end

  def word_list do
    "../assets/words.txt"
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.split(~r/\n/)
  end

  def random_word do
    word_list()
    |> Enum.random()
  end


  def compare_and_reverse do
    "had we but world enough, and time"
    |> String.graphemes()
    |> Enum.reverse()
    |> List.to_string()
    |> String.myers_difference("had we but bacon enough, and teacle")
  end
end

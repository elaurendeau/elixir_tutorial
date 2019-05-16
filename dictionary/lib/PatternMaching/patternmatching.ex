defmodule Patternmatching do
  def same({a, a}) do
    true
  end

  def same({_, _}) do
    false
  end

  def swap({left, right}) do
    {right, left, 1}
  end

  def len([]), do: 0
  def len([_head | tail]), do: 1 + len(tail)

  def pair([]), do: []
  def pair([first, second | tail]), do: [ { first + second } | pair(tail)]
  def pair([first | tail]), do: [ { first } | pair(tail) ]


  def even_length?([]), do: true
  def even_length?([_first, _second | tail]), do: true && even_length?(tail)
  def even_length?([_first | tail]), do: false && even_length?(tail)
end

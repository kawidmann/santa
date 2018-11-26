defmodule Santa do

  #API

  def pairs(path) do
    get_names(path)
    |> pair_matches
  end

  def chain(path) do
    get_names(path)
    |> chain_matches
  end 

  #utility
  
  def get_names(path) do
    File.stream!(path, [], :line)
    |> Enum.map(fn(line) -> fill_person(line) end)
  end

  defp fill_person(line) do
    [name, email, wishlist, do_not_match] = String.split(line, ",") |> Enum.map(&String.trim/1)
    %Person{name: name, 
            email: email, 
            wishlist: wishlist, 
            do_not_match: String.split(do_not_match, " ")}
  end

  def send_email(_giver, nil), do: raise "Cant send an email to no one"

  def send_email(giver, receiver) do
    IO.puts "#{giver.name} is buying for #{receiver.name}"
  end



  #Pairs

  def pair_matches(names) do
    names
    |> Enum.shuffle
    |> split_names
    |> Enum.map(&Enum.shuffle/1) #just so "Everyone" isnt always first
    |> Enum.zip
    |> Enum.each(fn({giver, receiver}) -> 
      send_email(giver, receiver)
      send_email(receiver, giver)
      end)
  end

  defp split_names(names) when rem(length(names), 2) == 0 do
    Enum.chunk_every(names, div(length(names), 2))
  end

  defp split_names(names) do
    split_names(["Everyone" | names])
  end

  #Chain 

  def chain_matches(names) do
    [final | tail] = Enum.shuffle(names)
    send_email(final, List.first(tail))
    chain_matches(tail, final)
  end

  defp chain_matches([end_of_list], final), do: send_email(end_of_list, final)

  defp chain_matches([next | tail], final) do
    send_email(next, List.first(tail))
    chain_matches(tail, final)
  end 

end


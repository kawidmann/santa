defmodule SantaTest do
  use ExUnit.Case
  doctest Santa

  setup do
  	{:ok, 
 	 path: "test/data/names",
 	 person: %Person{name: "Example1", email: "Example1@email.com", wishlist: "amazon.com/wishlist1"}}
  end

  test "read and fill struct", context do
  	[person | _] = Santa.get_names(context[:path])
  	assert person.name == context[:person].name
  	assert person.email == context[:person].email
  	assert person.wishlist == context[:person].wishlist
  	assert person.do_not_match == [""]
  end

  
end

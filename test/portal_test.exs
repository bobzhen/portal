defmodule PortalTest do
  use ExUnit.Case
  doctest Portal

  # test "the truth" do
  #  assert 1 + 1 == 2
  # end

  # https://github.com/elixir-lang/elixir/issues/2929
  # http://elixir-lang.org/docs/stable/ex_unit/ExUnit.Callbacks.html#content
  setup do
    Portal.shoot(:orange)
    Portal.shoot(:blue)
    portal = Portal.transfer(:orange, :blue, [1,2,3])

    on_exit fn ->
      Enum.each([:blue, :orange], fn(x) ->
        Process.unlink(Process.whereis(x))
        Process.exit(Process.whereis(:blue), :shutdown)
      end)
    end

    {:ok, [portal: portal]}
  end

  #  test "Door init state should exactly as given setup" do
  #    assert Portal.Door.get(:blue) == []
  #    assert Portal.Door.get(:orange) == Enum.reverse [1,2,3]
  #  end

  test "push_right: elem should be push from left to right if any", context do
    Portal.push_right(context[:portal])
    assert Portal.Door.get(:blue) == [3]
    assert Portal.Door.get(:orange) == [2, 1]
  end

  #  test "push_left: elem should be push from left to right if any" do
  #  end
end


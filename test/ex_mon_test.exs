defmodule ExMonTest do
  use ExUnit.Case
  import ExUnit.CaptureIO

  alias ExMon.Player

  describe "create_player/4" do
    test "returns a player" do
      expected_response = %Player{
        life: 100,
        moves: %{move_heal: :cura, move_avg: :soco, move_rnd: :chute},
        name: "Felipe"
      }

      assert expected_response == ExMon.create_player("Felipe", :chute, :soco, :cura)
    end
  end

  describe "start_game/1" do
    test "when start game should return message" do
      player = Player.build("Felipe", :chute, :soco, :cura)

      messages =
        capture_io(fn ->
          assert ExMon.start_game(player) == :ok
        end)

      assert messages =~ "The game is started!"
      assert messages =~ "status: :started"
    end
  end

  describe "make_move/1" do
    setup do
      player = Player.build("Felipe", :chute, :soco, :cura)

      capture_io(fn ->
        ExMon.start_game(player)
      end)

      :ok
    end

    test "when the move is valid, do the move and computer makes a move" do
      messages =
        capture_io(fn ->
          ExMon.make_move(:chute)
        end)

      assert messages =~ "The player attacked the computer"
      assert messages =~ "It's computer turn"
      assert messages =~ "It's computer turn"
    end

    test "when the move is invalid, returns an erro message" do
      messages =
        capture_io(fn ->
          ExMon.make_move(:wrong_move)
        end)

      assert messages =~ "Invalid move wrong_move"
    end
  end
end

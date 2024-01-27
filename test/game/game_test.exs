defmodule ExMon.GameTest do
  alias ExMon.Game
  alias ExMon.Player
  use ExUnit.Case

  describe "start/1" do
    test "starts the game state" do
      player = Player.build("Felipe", :chute, :soco, :cura)
      computer = Player.build("Robotinik", :kick, :punch, :heal)

      assert {:ok, _pid} = Game.start(computer, player)
    end
  end

  describe "info/0" do
    test "returns the correct game status" do
      player = Player.build("Felipe", :chute, :soco, :cura)
      computer = Player.build("Robotinik", :kick, :punch, :heal)
      Game.start(computer, player)

      expected_response = %{
        status: :started,
        player: %Player{
          life: 100,
          moves: %{move_heal: :cura, move_avg: :soco, move_rnd: :chute},
          name: "Felipe"
        },
        computer: %Player{
          life: 100,
          moves: %{move_heal: :heal, move_avg: :punch, move_rnd: :kick},
          name: "Robotinik"
        },
        turn: :player
      }

      assert expected_response == Game.info()
    end
  end

  describe "update/1" do
    test "returns the  game state updated" do
      player = Player.build("Felipe", :chute, :soco, :cura)
      computer = Player.build("Robotinik", :kick, :punch, :heal)
      Game.start(computer, player)

      expected_response = %{
        status: :started,
        player: %Player{
          life: 100,
          moves: %{move_heal: :cura, move_avg: :soco, move_rnd: :chute},
          name: "Felipe"
        },
        computer: %Player{
          life: 100,
          moves: %{move_heal: :heal, move_avg: :punch, move_rnd: :kick},
          name: "Robotinik"
        },
        turn: :player
      }

      assert expected_response == Game.info()

      new_state = %{
        status: :started,
        player: %Player{
          life: 50,
          moves: %{move_heal: :cura, move_avg: :soco, move_rnd: :chute},
          name: "Felipe"
        },
        computer: %Player{
          life: 50,
          moves: %{move_heal: :heal, move_avg: :punch, move_rnd: :kick},
          name: "Robotinik"
        },
        turn: :player
      }

      Game.update(new_state)

      expected_response = %{new_state | turn: :computer, status: :continue}

      assert expected_response == Game.info()
    end
  end

  describe "player/0" do
    test "should return the player" do
      player = Player.build("Felipe", :chute, :soco, :cura)
      computer = Player.build("Robotinik", :kick, :punch, :heal)
      Game.start(computer, player)

      expected_response = %ExMon.Player{
        life: 100,
        moves: %{move_heal: :cura, move_avg: :soco, move_rnd: :chute},
        name: "Felipe"
      }

      assert expected_response == Game.player()
    end
  end

  describe "turn/0" do
    test "should return who is the turn" do
      player = Player.build("Felipe", :chute, :soco, :cura)
      computer = Player.build("Robotinik", :kick, :punch, :heal)
      Game.start(computer, player)

      assert :player == Game.turn()
    end
  end

  describe "fetch_player/0" do
    test "should return who is the turn" do
      player = Player.build("Felipe", :chute, :soco, :cura)
      computer = Player.build("Robotinik", :kick, :punch, :heal)
      Game.start(computer, player)

      expected_response = %Player{
        life: 100,
        moves: %{move_heal: :cura, move_avg: :soco, move_rnd: :chute},
        name: "Felipe"
      }

      assert expected_response == Game.fetch_player(:player)
    end
  end
end

defmodule Pruebas do
  @moduledoc false
  def init do
    Agent.start_link(fn -> 0 end, name: __MODULE__)
  end

  def reset do
    Agent.update(__MODULE__, fn _ -> 0 end)
  end

  def gen_var do
    x = Agent.get_and_update(__MODULE__, fn x -> {x, x + 1} end)
    "X#{x}"
  end

  def unify_gen(theta, t1, t2) do
    IO.puts("Unifying #{inspect(t1)} and #{inspect(t2)} under #{inspect(theta)}")
    case Unification.unify(t1, t2, theta) do
      :unmatch -> []
      theta2 -> [theta2]
    end
  end

  ##############################################################################

  # defcore pred1(X) do
  #   X = 5
  # end

  def pred1(t1) do
    x1 = gen_var()

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}]))

      (fn th3 ->
         (fn th5 -> unify_gen(th5, {:var, x1}, {:ground, 5}) end).(th3)
         |> Stream.flat_map(fn th4 -> (fn th6 -> [th6] end).(th4) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1]))
    end
  end

  # > Pruebas.pred1({:ground, 4}).(%{}) |> Enum.into([])
  # > Pruebas.pred1({:ground, 5}).(%{}) |> Enum.into([])
  # > Pruebas.pred1({:var, Y}).(%{}) |> Enum.into([])

  ##############################################################################

  # defcore pred2(X, Y) do
  #   X = 5, Y = 6
  # end

  def pred2(t1, t2) do
    x1 = gen_var()
    x2 = gen_var()

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}, {x2, t2}]))

      (fn th3 ->
         (fn th5 -> unify_gen(th5, {:var, x1}, {:ground, 5}) end).(th3)
         |> Stream.flat_map(fn th4 ->
           (fn th5 ->
              (fn th7 -> unify_gen(th7, {:var, x2}, {:ground, 6}) end).(th5)
              |> Stream.flat_map(fn th6 -> (fn th7 -> [th7] end).(th6) end)
            end).(th4)
         end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1, x2]))
    end
  end

  # > Pruebas.pred2({:ground, 5}, {:ground, 6}).(%{}) |> Enum.into([])
  # > Pruebas.pred2({:ground, 5}, {:ground, 4}).(%{}) |> Enum.into([])
  # > Pruebas.pred2({:ground, 4}, {:var, Z}).(%{}) |> Enum.into([])
  # > Pruebas.pred2({:ground, 5}, {:var, Z}).(%{}) |> Enum.into([])
  # > Pruebas.pred2({:var, Z1}, {:var, Z2}).(%{}) |> Enum.into([])

  ##############################################################################

  # defcore pred3(X) do
  #   choice do
  #     X = 1
  #   else
  #     X = 2
  #   end
  # end

  def pred3(t1) do
    x1 = gen_var()

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}]))

      (fn th3 ->
         (fn th6 ->
            [
              fn th7 -> unify_gen(th7, {:var, x1}, {:ground, 1}) end,
              fn th8 -> unify_gen(th8, {:var, x1}, {:ground, 2}) end
            ]
            |> Stream.flat_map(fn f -> f.(th6) end)
          end).(th3)
         |> Stream.flat_map(fn th4 -> (fn th5 -> [th5] end).(th4) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1]))
    end
  end

  # > Pruebas.pred3({:ground, 1}).(%{}) |> Enum.into([])
  # > Pruebas.pred3({:ground, 2}).(%{}) |> Enum.into([])
  # > Pruebas.pred3({:ground, 3}).(%{}) |> Enum.into([])
  # > Pruebas.pred3({:var, X}).(%{}) |> Enum.into([])

  ##############################################################################

  # defcore pred4(X) do
  #   choice do
  #     X = 1
  #   else
  #     X = 2
  #   end
  # end

  def pred4(t1) do
    x1 = gen_var()

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}]))

      (fn th3 ->
         (fn th4 ->
            [
              (fn th5 ->
                (fn th6 ->
                    unify_gen(th6, {:var, x1}, {:ground, 1}) end).(th5)
                    |> Stream.flat_map(fn th7 -> (fn th8 -> [th8] end).(th7)
                end)
              end),
              (fn th9 ->
                (fn th10 ->
                  unify_gen(th10, {:var, x1}, {:ground, 2}) end).(th9)
                  |> Stream.flat_map(fn th11 -> (fn th12 -> [th12] end).(th11)
                end)
              end)
            ]
            |> Stream.flat_map(fn f -> f.(th4) end)
          end).(th3)
         |> Stream.flat_map(fn th13 -> (fn th14 -> [th14] end).(th13) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1]))
    end
  end

  # > Pruebas.pred4({:ground, 1}).(%{}) |> Enum.into([])
  # > Pruebas.pred4({:ground, 2}).(%{}) |> Enum.into([])
  # > Pruebas.pred4({:ground, 3}).(%{}) |> Enum.into([])
  # > Pruebas.pred4({:var, X}).(%{}) |> Enum.into([])

  ##############################################################################

  # defcore pred5(X, Y) do
  #   choice do
  #     X = 1
  #   else
  #     X = 2
  #   end
  #   Y = 3
  # end

  def pred5(t1, t2) do
    x1 = gen_var()
    x2 = gen_var()
    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}, {x2, t2}]))
      (fn th3 ->
        (fn th4 -> [
          (fn th5 ->
            (fn th6 -> unify_gen(th6, {:var, x1}, {:ground, 1}) end).(th5)
            |> Stream.flat_map(fn th7 -> (fn th8 -> [th8] end).(th7) end)
          end),
          (fn th9 ->
            (fn th10 -> unify_gen(th10, {:var, x1}, {:ground, 2}) end).(th9)
            |> Stream.flat_map(fn th11 -> (fn th12 -> [th12] end).(th11) end)
          end)
          ]
          |> Stream.flat_map(fn f -> f.(th4) end)
        end).(th3)
        |> Stream.flat_map(fn th13 ->
                            (fn th14 ->
                              (fn th15 -> unify_gen(th15, {:var, x2}, {:ground, 3}) end).(th14)
                              |> Stream.flat_map(fn th16 -> (fn th17 -> [th17] end).(th16) end)
                             end).(th13)
                           end)
      end).(th2)
      |> Stream.map(&Map.drop(&1, [x1, x2]))
    end
  end

  # Pruebas.pred5({:var, Z}, {:ground, 3}).(%{}) |> Enum.into([])
  # Pruebas.pred5({:var, Z1}, {:var, Z2}).(%{}) |> Enum.into([])
  # Pruebas.pred5({:ground, 1}, {:ground, 3}).(%{}) |> Enum.into([])
  # Pruebas.pred5({:ground, 2}, {:ground, 3}).(%{}) |> Enum.into([])
  # Pruebas.pred5({:ground, 3}, {:ground, 1}).(%{}) |> Enum.into([])

  ##############################################################################

  # defcore pred6(X, Y) do
  #   X = Z, Y = Z
  # end

  def pred6(t1, t2) do
    # Delta = [X -> x1, Y -> x2, Z -> x3]
    x1 = gen_var()
    x2 = gen_var()
    x3 = gen_var()

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}, {x2, t2}]))

      (fn th3 ->
         (fn th5 -> unify_gen(th5, {:var, x1}, {:var, x3}) end).(th3)
         |> Stream.flat_map(fn th4 ->
           (fn th6 ->
              (fn th9 -> unify_gen(th9, {:var, x2}, {:var, x3}) end).(th6)
              |> Stream.flat_map(fn th7 -> (fn th8 -> [th8] end).(th7) end)
            end).(th4)
         end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1, x2, x3]))
    end
  end

  # > Pruebas.pred6({:ground, 3}, {:ground, 4}).(%{}) |> Enum.into([])
  # > Pruebas.pred6({:ground, 3}, {:ground, 3}).(%{}) |> Enum.into([])
  # > Pruebas.pred6({:ground, 3}, {:var, "V"}).(%{}) |> Enum.into([])
  # > Pruebas.pred6({:ground, 3}, {:var, "V"}).(%{}) |> Enum.into([])
  # > Pruebas.pred6({:var, "V"}, {:var, "V"}).(%{}) |> Enum.into([])
  # > Pruebas.pred6({:var, "W"}, {:var, "V"}).(%{}) |> Enum.into([])
end

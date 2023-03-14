defmodule Example do
  import Core
  require Logger

  def pred1(t1) do
    x1 = VarBuilder.gen_var()
    nil

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}]))

      (fn th1 ->
         (fn th -> unify_gen(th, {:var, x1}, {:ground, 5}) end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1]))
    end
  end

  def pred2(t1, t2) do
    (
      x1 = VarBuilder.gen_var()
      x2 = VarBuilder.gen_var()
    )

    nil

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}, {x2, t2}]))

      (fn th1 ->
         (fn th -> unify_gen(th, {:var, x1}, {:ground, 5}) end).(th1)
         |> Stream.flat_map(fn th2 ->
           (fn th1 ->
              (fn th -> unify_gen(th, {:var, x2}, {:ground, 6}) end).(th1)
              |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
            end).(th2)
         end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1, x2]))
    end
  end

  def pred3(t1, t2) do
    (
      x1 = VarBuilder.gen_var()
      x2 = VarBuilder.gen_var()
    )

    y1 = VarBuilder.gen_var()

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}, {x2, t2}]))

      (fn th1 ->
         (fn th -> unify_gen(th, {:var, x1}, {:var, y1}) end).(th1)
         |> Stream.flat_map(fn th2 ->
           (fn th1 ->
              (fn th -> unify_gen(th, {:var, x2}, {:var, y1}) end).(th1)
              |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
            end).(th2)
         end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1, x2, y1]))
    end
  end

  def pred4(t1) do
    x1 = VarBuilder.gen_var()
    y1 = VarBuilder.gen_var()

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}]))

      (fn th1 ->
         (fn th -> unify_gen(th, {:var, y1}, {:var, x1}) end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1, y1]))
    end
  end

  def pred5 do
    nil
    y1 = VarBuilder.gen_var()

    fn th1 ->
      th2 = Map.merge(th1, Map.new([]))

      (fn th1 ->
         (fn th -> unify_gen(th, {:var, y1}, {:ground, 1}) end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [y1]))
    end
  end

  def pred6(t1) do
    x1 = VarBuilder.gen_var()
    nil

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}]))

      (fn th1 ->
         (fn th ->
            [
              fn th1 ->
                (fn th -> unify_gen(th, {:var, x1}, {:ground, 1}) end).(th1)
                |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
              end,
              fn th1 ->
                (fn th -> unify_gen(th, {:var, x1}, {:ground, 2}) end).(th1)
                |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
              end
            ]
            |> Stream.flat_map(fn f -> f.(th) end)
          end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1]))
    end
  end

  def pred7(t1) do
    x1 = VarBuilder.gen_var()
    nil

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}]))

      (fn th1 ->
         (fn th ->
            [
              fn th1 ->
                (fn th -> unify_gen(th, {:var, x1}, {:ground, 1}) end).(th1)
                |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
              end,
              fn th1 ->
                (fn th -> unify_gen(th, {:var, x1}, {:ground, 2}) end).(th1)
                |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
              end,
              fn th1 ->
                (fn th -> unify_gen(th, {:var, x1}, {:ground, 3}) end).(th1)
                |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
              end
            ]
            |> Stream.flat_map(fn f -> f.(th) end)
          end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1]))
    end
  end

  def pred8(t1, t2) do
    (
      x1 = VarBuilder.gen_var()
      x2 = VarBuilder.gen_var()
    )

    nil

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}, {x2, t2}]))

      (fn th1 ->
         (fn th ->
            [
              fn th1 ->
                (fn th -> unify_gen(th, {:var, x1}, {:ground, 1}) end).(th1)
                |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
              end,
              fn th1 ->
                (fn th -> unify_gen(th, {:var, x1}, {:ground, 2}) end).(th1)
                |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
              end
            ]
            |> Stream.flat_map(fn f -> f.(th) end)
          end).(th1)
         |> Stream.flat_map(fn th2 ->
           (fn th1 ->
              (fn th -> unify_gen(th, {:var, x2}, {:ground, 3}) end).(th1)
              |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
            end).(th2)
         end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1, x2]))
    end
  end

  def pred9(t1, t2) do
    (
      x1 = VarBuilder.gen_var()
      x2 = VarBuilder.gen_var()
    )

    nil

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}, {x2, t2}]))

      (fn th1 ->
         (fn th ->
            [
              fn th1 ->
                (fn th -> unify_gen(th, {:var, x1}, {:ground, 1}) end).(th1)
                |> Stream.flat_map(fn th2 ->
                  (fn th1 ->
                     (fn th -> unify_gen(th, {:var, x2}, {:ground, 3}) end).(th1)
                     |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
                   end).(th2)
                end)
              end,
              fn th1 ->
                (fn th -> unify_gen(th, {:var, x1}, {:ground, 2}) end).(th1)
                |> Stream.flat_map(fn th2 ->
                  (fn th1 ->
                     (fn th -> unify_gen(th, {:var, x2}, {:ground, 4}) end).(th1)
                     |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
                   end).(th2)
                end)
              end
            ]
            |> Stream.flat_map(fn f -> f.(th) end)
          end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1, x2]))
    end
  end

  def pred12 do
    nil
    nil

    fn th1 ->
      th2 = Map.merge(th1, Map.new([]))

      (fn th1 ->
         (fn th -> pred1({:ground, 5}).(th) end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, []))
    end
  end

  def pred13(t1) do
    x1 = VarBuilder.gen_var
    nil

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}]))

      (fn th1 ->
         (fn th -> pred1({:var, x1}).(th) end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1]))
    end
  end

  def pred14(t1) do
    x1 = VarBuilder.gen_var

    (
      y1 = VarBuilder.gen_var
      y2 = VarBuilder.gen_var
    )

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}]))

      (fn th1 ->
         (fn th -> unify_gen(th, {:var, y1}, {:ground, 3}) end).(th1)
         |> Stream.flat_map(fn th2 ->
           (fn th1 ->
              (fn th -> unify_gen(th, {:var, y2}, {:ground, 4}) end).(th1)
              |> Stream.flat_map(fn th2 ->
                (fn th1 ->
                   (fn th ->
                      unify_gen(
                        th,
                        {:var, x1},
                        (
                          (
                            x1 = groundify(th, {:var, y1})
                            x2 = groundify(th, {:var, y2})
                          )
                          # Logger.info("groundify(th, {:var, y1}): #{inspect(groundify(th, {:var, y1}))}")
                          # Logger.info("groundify(th, {:var, y2}): #{inspect(groundify(th, {:var, y2}))}")
                          {:ground, g(x1, x2)}
                        )
                      )
                    end).(th1)
                   |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
                 end).(th2)
              end)
            end).(th2)
         end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1, y1, y2]))
    end
  end

  # def pred15 do
  #   nil
  #   nil

  #   fn th1 ->
  #     th2 = Map.merge(th1, Map.new([]))

  #     (fn th1 ->
  #        (fn th -> check_b(th, groundify(th, {:ground, 1})) end).(th1)
  #        |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
  #      end).(th2)
  #     |> Stream.map(&Map.drop(&1, []))
  #   end
  # end

  def pred15 do
    nil
    y1 = VarBuilder.gen_var

    fn th1 ->
      th2 = Map.merge(th1, Map.new([]))

      (fn th1 ->
         (fn th -> check_b(th, groundify(th, {:var, y1})) end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [y1]))
    end
  end

  def pred16(t1, t2) do
    (
      x1 = VarBuilder.gen_var
      x2 = VarBuilder.gen_var
    )

    nil

    # Logger.info("build_tuple(var: x1, var: x2): #{inspect(build_tuple(var: x1, var: x2))}")
    # Logger.info("build_tuple(ground: 1, ground: 2): #{inspect(build_tuple(ground: 1, ground: 2))}")

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}, {x2, t2}]))

      (fn th1 ->
         (fn th ->
            unify_gen(th, build_tuple(var: x1, var: x2), build_tuple(ground: 1, ground: 2))
          end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1, x2]))
    end
  end

  def pred17(t1, t2) do
    (
      x1 = VarBuilder.gen_var
      x2 = VarBuilder.gen_var
    )

    (
      y1 = VarBuilder.gen_var
      y2 = VarBuilder.gen_var
    )

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}, {x2, t2}]))

      (fn th1 ->
         (fn th -> unify_gen(th, build_tuple(var: y1, var: y2), build_tuple(var: x1, var: x2)) end).(
           th1
         )
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1, x2, y1, y2]))
    end
  end

  def pred18(t1, t2) do
    (
      x1 = VarBuilder.gen_var
      x2 = VarBuilder.gen_var
    )

    nil

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}, {x2, t2}]))

      (fn th1 ->
         (fn th ->
            [
              fn th1 ->
                (fn th ->
                   unify_gen(th, build_tuple(var: x1, var: x2), build_tuple(ground: 1, ground: 3))
                 end).(th1)
                |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
              end,
              fn th1 ->
                (fn th ->
                   unify_gen(th, build_tuple(var: x1, var: x2), build_tuple(ground: 2, ground: 4))
                 end).(th1)
                |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
              end
            ]
            |> Stream.flat_map(fn f -> f.(th) end)
          end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1, x2]))
    end
  end

  def pred20(t1) do
    x1 = VarBuilder.gen_var

    (
      y1 = VarBuilder.gen_var
      y2 = VarBuilder.gen_var
    )

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}]))

      (fn th1 ->
         (fn th -> unify_gen(th, {:var, x1}, build_tuple(var: y1, var: y2)) end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1, y1, y2]))
    end
  end

  def pred21(t1) do
    x1 = VarBuilder.gen_var
    nil

    # Logger.info("build_list({:ground, 1}, build_list({:ground, 2}, build_list({:ground, 3}, []))): #{inspect(build_list({:ground, 1}, build_list({:ground, 2}, build_list({:ground, 3}, []))))}")

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}]))

      (fn th1 ->
         (fn th ->
            unify_gen(
              th,
              {:var, x1},
              build_list({:ground, 1}, build_list({:ground, 2}, build_list({:ground, 3}, [])))
            )
          end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1]))
    end
  end

  def pred22(t1, t2, t3) do
    (
      x1 = VarBuilder.gen_var
      x2 = VarBuilder.gen_var
      x3 = VarBuilder.gen_var
    )

    nil

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}, {x2, t2}, {x3, t3}]))

      (fn th1 ->
         (fn th ->
            unify_gen(
              th,
              build_list({:var, x1}, build_list({:var, x2}, build_list({:var, x3}, []))),
              build_list({:ground, 1}, build_list({:ground, 2}, build_list({:ground, 3}, [])))
            )
          end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1, x2, x3]))
    end
  end

  def pred23 do
    nil

    (
      y1 = VarBuilder.gen_var
      y2 = VarBuilder.gen_var
      y3 = VarBuilder.gen_var
    )

    fn th1 ->
      th2 = Map.merge(th1, Map.new([]))

      (fn th1 ->
         (fn th ->
            unify_gen(
              th,
              build_list({:var, y1}, build_list({:var, y2}, build_list({:var, y3}, []))),
              build_list({:ground, 1}, build_list({:ground, 2}, build_list({:ground, 3}, [])))
            )
          end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [y1, y2, y3]))
    end
  end

  def pred24 do
    nil

    (
      y1 = VarBuilder.gen_var
      y2 = VarBuilder.gen_var
      y3 = VarBuilder.gen_var
      y4 = VarBuilder.gen_var
    )

    fn th1 ->
      th2 = Map.merge(th1, Map.new([]))

      (fn th1 ->
         (fn th ->
            unify_gen(
              th,
              build_list(
                {:var, y1},
                build_list({:var, y2}, build_list({:var, y3}, build_list({:var, y4}, [])))
              ),
              build_list({:ground, 1}, build_list({:ground, 2}, build_list({:ground, 3}, [])))
            )
          end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [y1, y2, y3, y4]))
    end
  end

  def pred25(t1) do
    x1 = VarBuilder.gen_var
    nil

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}]))

      (fn th1 ->
         (fn th ->
            unify_gen(
              th,
              {:var, x1},
              build_list(
                build_list({:ground, 1}, build_list({:ground, 2}, build_list({:ground, 3}, []))),
                []
              )
            )
          end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1]))
    end
  end

  def pred28(t1) do
    x1 = VarBuilder.gen_var
    nil

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}]))

      (fn th1 ->
         (fn th -> unify_gen(th, {:var, x1}, {:ground, 3}) end).(th1)
         |> Stream.flat_map(fn th2 ->
           (fn th1 ->
              (fn th -> check_b(th, groundify(th, {:var, x1})) end).(th1)
              |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
            end).(th2)
         end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1]))
    end
  end
end

defmodule Example do
  import LogicElixir.Defcore
  # import LogicElixir.TermBuilder
  require Logger

  def pred1(t1) do
    x1 = LogicElixir.VarBuilder.gen_var()
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
      x1 = LogicElixir.VarBuilder.gen_var()
      x2 = LogicElixir.VarBuilder.gen_var()
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
      x1 = LogicElixir.VarBuilder.gen_var()
      x2 = LogicElixir.VarBuilder.gen_var()
    )

    y1 = LogicElixir.VarBuilder.gen_var()

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
    x1 = LogicElixir.VarBuilder.gen_var()
    y1 = LogicElixir.VarBuilder.gen_var()

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
    y1 = LogicElixir.VarBuilder.gen_var()

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
    x1 = LogicElixir.VarBuilder.gen_var()
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
    x1 = LogicElixir.VarBuilder.gen_var()
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
      x1 = LogicElixir.VarBuilder.gen_var()
      x2 = LogicElixir.VarBuilder.gen_var()
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
      x1 = LogicElixir.VarBuilder.gen_var()
      x2 = LogicElixir.VarBuilder.gen_var()
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

  def pred11 do
    nil

    (
      y1 = LogicElixir.VarBuilder.gen_var()
      y2 = LogicElixir.VarBuilder.gen_var()
      y3 = LogicElixir.VarBuilder.gen_var()
    )

    fn th1 ->
      th2 = Map.merge(th1, Map.new([]))

      (fn th1 ->
         (fn th -> unify_gen(th, {:var, y1}, var: y2, var: y3) end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [y1, y2, y3]))
    end
  end

  def pred110(t1) do
    x1 = LogicElixir.VarBuilder.gen_var()

    (
      y1 = LogicElixir.VarBuilder.gen_var()
      y2 = LogicElixir.VarBuilder.gen_var()
    )

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}]))

      (fn th1 ->
         (fn th -> unify_gen(th, {:var, x1}, var: y1, var: y2) end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1, y1, y2]))
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
    x1 = LogicElixir.VarBuilder.gen_var()
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
    x1 = LogicElixir.VarBuilder.gen_var()

    (
      y1 = LogicElixir.VarBuilder.gen_var()
      y2 = LogicElixir.VarBuilder.gen_var()
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

                          {:ground, Template.f(x1, x2)}
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

  def pred140(t1) do
    x1 = LogicElixir.VarBuilder.gen_var()

    (
      y1 = LogicElixir.VarBuilder.gen_var()
      y2 = LogicElixir.VarBuilder.gen_var()
      y3 = LogicElixir.VarBuilder.gen_var()
    )

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}]))

      (fn th1 ->
         (fn th -> unify_gen(th, {:var, y1}, {:ground, 3}) end).(th1)
         |> Stream.flat_map(fn th2 ->
           (fn th1 ->
              (fn th -> unify_gen(th, {:var, y2}, {:var, y3}) end).(th1)
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

                          {:ground, Template.f(x1, x2)}
                        )
                      )
                    end).(th1)
                   |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
                 end).(th2)
              end)
            end).(th2)
         end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1, y1, y2, y3]))
    end
  end

  def pred141() do
    nil
    nil

    fn th1 ->
      th2 = Map.merge(th1, Map.new([]))

      (fn th1 ->
         (fn th -> Template.f({:ground, 3}, {:ground, 4}).(th) end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, []))
    end
  end

  def pred15 do
    nil
    y1 = LogicElixir.VarBuilder.gen_var()

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
      x1 = LogicElixir.VarBuilder.gen_var()
      x2 = LogicElixir.VarBuilder.gen_var()
    )

    nil

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}, {x2, t2}]))

      (fn th1 ->
         (fn th ->
            unify_gen(
              th,
              LogicElixir.TermBuilder.build_tuple(var: x1, var: x2),
              LogicElixir.TermBuilder.build_tuple(ground: 1, ground: 2)
            )
          end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1, x2]))
    end
  end

  def pred17(t1, t2) do
    (
      x1 = LogicElixir.VarBuilder.gen_var()
      x2 = LogicElixir.VarBuilder.gen_var()
    )

    (
      y1 = LogicElixir.VarBuilder.gen_var()
      y2 = LogicElixir.VarBuilder.gen_var()
    )

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}, {x2, t2}]))

      (fn th1 ->
         (fn th ->
            unify_gen(
              th,
              LogicElixir.TermBuilder.build_tuple(var: y1, var: y2),
              LogicElixir.TermBuilder.build_tuple(var: x1, var: x2)
            )
          end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1, x2, y1, y2]))
    end
  end

  def pred18(t1, t2) do
    (
      x1 = LogicElixir.VarBuilder.gen_var()
      x2 = LogicElixir.VarBuilder.gen_var()
    )

    nil

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}, {x2, t2}]))

      (fn th1 ->
         (fn th ->
            [
              fn th1 ->
                (fn th ->
                   unify_gen(
                     th,
                     LogicElixir.TermBuilder.build_tuple(var: x1, var: x2),
                     LogicElixir.TermBuilder.build_tuple(ground: 1, ground: 3)
                   )
                 end).(th1)
                |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
              end,
              fn th1 ->
                (fn th ->
                   unify_gen(
                     th,
                     LogicElixir.TermBuilder.build_tuple(var: x1, var: x2),
                     LogicElixir.TermBuilder.build_tuple(ground: 2, ground: 4)
                   )
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

  def pred19() do
    nil
    y1 = LogicElixir.VarBuilder.gen_var()

    fn th1 ->
      th2 = Map.merge(th1, Map.new([]))

      (fn th1 ->
         (fn th -> pred1({:var, y1}).(th) end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [y1]))
    end
  end

  def pred20(t1) do
    x1 = LogicElixir.VarBuilder.gen_var()

    (
      y1 = LogicElixir.VarBuilder.gen_var()
      y2 = LogicElixir.VarBuilder.gen_var()
    )

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}]))

      (fn th1 ->
         (fn th -> unify_gen(th, {:var, x1}, LogicElixir.TermBuilder.build_tuple(var: y1, var: y2)) end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1, y1, y2]))
    end
  end

  def pred21(t1) do
    x1 = LogicElixir.VarBuilder.gen_var()
    nil

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}]))

      (fn th1 ->
         (fn th ->
            unify_gen(
              th,
              {:var, x1},
              LogicElixir.TermBuilder.build_list(
                {:ground, 1},
                LogicElixir.TermBuilder.build_list({:ground, 2}, LogicElixir.TermBuilder.build_list({:ground, 3}, []))
              )
            )
          end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1]))
    end
  end

  def pred22(t1, t2, t3) do
    (
      x1 = LogicElixir.VarBuilder.gen_var()
      x2 = LogicElixir.VarBuilder.gen_var()
      x3 = LogicElixir.VarBuilder.gen_var()
    )

    nil

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}, {x2, t2}, {x3, t3}]))

      (fn th1 ->
         (fn th ->
            unify_gen(
              th,
              LogicElixir.TermBuilder.build_list(
                {:var, x1},
                LogicElixir.TermBuilder.build_list({:var, x2}, LogicElixir.TermBuilder.build_list({:var, x3}, []))
              ),
              LogicElixir.TermBuilder.build_list(
                {:ground, 1},
                LogicElixir.TermBuilder.build_list({:ground, 2}, LogicElixir.TermBuilder.build_list({:ground, 3}, []))
              )
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
      y1 = LogicElixir.VarBuilder.gen_var()
      y2 = LogicElixir.VarBuilder.gen_var()
      y3 = LogicElixir.VarBuilder.gen_var()
    )

    fn th1 ->
      th2 = Map.merge(th1, Map.new([]))

      (fn th1 ->
         (fn th ->
            unify_gen(
              th,
              LogicElixir.TermBuilder.build_list(
                {:var, y1},
                LogicElixir.TermBuilder.build_list({:var, y2}, LogicElixir.TermBuilder.build_list({:var, y3}, []))
              ),
              LogicElixir.TermBuilder.build_list(
                {:ground, 1},
                LogicElixir.TermBuilder.build_list({:ground, 2}, LogicElixir.TermBuilder.build_list({:ground, 3}, []))
              )
            )
          end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [y1, y2, y3]))
    end
  end

  def pred24(t1, t2, t3) do
    (
      x1 = LogicElixir.VarBuilder.gen_var()
      x2 = LogicElixir.VarBuilder.gen_var()
      x3 = LogicElixir.VarBuilder.gen_var()
    )

    nil

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}, {x2, t2}, {x3, t3}]))

      (fn th1 ->
         (fn th ->
            unify_gen(th, [{:var, x1} | [{:var, x2} | {:var, x3}]],
              ground: 1,
              ground: 2,
              ground: 3
            )
          end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1, x2, x3]))
    end
  end

  def pred25(t1) do
    x1 = LogicElixir.VarBuilder.gen_var()
    nil

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}]))

      (fn th1 ->
         (fn th ->
            unify_gen(
              th,
              {:var, x1},
              LogicElixir.TermBuilder.build_list(
                LogicElixir.TermBuilder.build_list(
                  {:ground, 1},
                  LogicElixir.TermBuilder.build_list({:ground, 2}, LogicElixir.TermBuilder.build_list({:ground, 3}, []))
                ),
                []
              )
            )
          end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1]))
    end
  end

  def pred26 do
    nil
    nil

    fn th1 ->
      th2 = Map.merge(th1, Map.new([]))

      (fn th1 ->
         (fn th ->
            check_b(
              th,
              groundify(
                th,
                (
                  (
                    x1 = groundify(%{}, {:ground, 3})
                    x2 = groundify(%{}, {:ground, 4})
                  )

                  {:ground, Template.f(x1, x2)}
                )
              )
            )
          end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, []))
    end
  end

  def pred27 do
    nil
    nil

    fn th1 ->
      th2 = Map.merge(th1, Map.new([]))

      (fn th1 ->
         (fn th -> check_b(th, groundify(th, {:ground, 3})) end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, []))
    end
  end

  def pred28(t1) do
    x1 = LogicElixir.VarBuilder.gen_var()
    nil

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}]))

      (fn th1 ->
         (fn th -> unify_gen(th, {:var, x1}, {:ground, 3}) end).(th1)
         |> Stream.flat_map(fn th2 ->
           (fn th1 ->
              (fn th ->
                 check_b(
                   th,
                   groundify(
                     th,
                     (
                       (
                         x1 = groundify(th, {:var, x1})
                         x2 = groundify(th, {:ground, 4})
                       )

                       {:ground, x1 + x2}
                     )
                   )
                 )
               end).(th1)
              |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
            end).(th2)
         end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1]))
    end
  end

  def pred29(t1) do
    x1 = LogicElixir.VarBuilder.gen_var()
    nil

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}]))

      (fn th1 ->
         (fn th ->
            unify_gen(
              th,
              {:var, x1},
              LogicElixir.TermBuilder.build_list(LogicElixir.TermBuilder.build_list({:ground, 1}, []), [])
            )
          end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1]))
    end
  end

  def pred291(t1) do
    x1 = LogicElixir.VarBuilder.gen_var()
    nil

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}]))

      (fn th1 ->
         (fn th -> unify_gen(th, {:var, x1}, LogicElixir.TermBuilder.build_list([ground: 1], [])) end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1]))
    end
  end

  def pred292(t1) do
    x1 = LogicElixir.VarBuilder.gen_var()
    nil

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}]))

      (fn th1 ->
         (fn th -> unify_gen(th, {:var, x1}, ground: 1) end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1]))
    end
  end

  def pred30(t1) do
    x1 = LogicElixir.VarBuilder.gen_var()
    nil

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}]))

      (fn th1 ->
         (fn th -> unify_gen(th, {:var, x1}, ground: 1, ground: 2) end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1]))
    end
  end

  def pred301(t1) do
    x1 = LogicElixir.VarBuilder.gen_var()
    nil

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}]))

      (fn th1 ->
         (fn th -> unify_gen(th, {:var, x1}, ground: 1, ground: 2) end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1]))
    end
  end

  def pred302(t1) do
    x1 = LogicElixir.VarBuilder.gen_var()
    nil

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}]))

      (fn th1 ->
         (fn th -> unify_gen(th, {:var, x1}, ground: 1, ground: 2) end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1]))
    end
  end

  def pred31(t1, t2) do
    (
      x1 = LogicElixir.VarBuilder.gen_var()
      x2 = LogicElixir.VarBuilder.gen_var()
    )

    nil

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}, {x2, t2}]))

      (fn th1 ->
         (fn th -> unify_gen(th, {:var, x1}, {:ground, 1}) end).(th1)
         |> Stream.flat_map(fn th2 ->
           (fn th1 ->
              (fn th -> unify_gen(th, {:var, x2}, var: x1, ground: 2, ground: 3) end).(th1)
              |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
            end).(th2)
         end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1, x2]))
    end
  end

  def pred311(t1, t2) do
    (
      x1 = LogicElixir.VarBuilder.gen_var()
      x2 = LogicElixir.VarBuilder.gen_var()
    )

    nil

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}, {x2, t2}]))

      (fn th1 ->
         (fn th -> unify_gen(th, {:var, x1}, {:ground, 1}) end).(th1)
         |> Stream.flat_map(fn th2 ->
           (fn th1 ->
              (fn th -> unify_gen(th, {:var, x2}, var: x1, ground: 2, ground: 3) end).(th1)
              |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
            end).(th2)
         end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1, x2]))
    end
  end

  def pred33(t1) do
    x1 = LogicElixir.VarBuilder.gen_var()

    (
      y1 = LogicElixir.VarBuilder.gen_var()
      y2 = LogicElixir.VarBuilder.gen_var()
      y3 = LogicElixir.VarBuilder.gen_var()
    )

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}]))

      (fn th1 ->
         (fn th -> unify_gen(th, {:var, x1}, var: y1, var: y2, var: y3) end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1, y1, y2, y3]))
    end
  end

  def pred40(t1) do
    x1 = LogicElixir.VarBuilder.gen_var()

    (
      y1 = LogicElixir.VarBuilder.gen_var()
      y2 = LogicElixir.VarBuilder.gen_var()
      y3 = LogicElixir.VarBuilder.gen_var()
    )

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}]))

      (fn th1 ->
         (fn th ->
            [
              fn th1 ->
                (fn th -> unify_gen(th, {:var, x1}, [{:var, y1} | []]) end).(th1)
                |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
              end,
              fn th1 ->
                (fn th -> unify_gen(th, {:var, x1}, [{:var, y1} | [var: y2]]) end).(th1)
                |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
              end,
              fn th1 ->
                (fn th -> unify_gen(th, {:var, x1}, [{:var, y1} | [{:var, y2} | [var: y3]]]) end).(
                  th1
                )
                |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
              end
            ]
            |> Stream.flat_map(fn f -> f.(th) end)
          end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1, y1, y2, y3]))
    end
  end

  def pred401(t1) do
    x1 = LogicElixir.VarBuilder.gen_var()

    (
      y1 = LogicElixir.VarBuilder.gen_var()
      y2 = LogicElixir.VarBuilder.gen_var()
      y3 = LogicElixir.VarBuilder.gen_var()
    )

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
                (fn th -> unify_gen(th, {:var, x1}, [{:var, y1} | []]) end).(th1)
                |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
              end,
              fn th1 ->
                (fn th -> unify_gen(th, {:var, x1}, [{:var, y1} | [var: y2]]) end).(th1)
                |> Stream.flat_map(fn th2 ->
                  (fn th1 ->
                     (fn th ->
                        unify_gen(th, {:var, x1}, [{:var, y1} | [{:var, y2} | [var: y3]]])
                      end).(th1)
                     |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
                   end).(th2)
                end)
              end
            ]
            |> Stream.flat_map(fn f -> f.(th) end)
          end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1, y1, y2, y3]))
    end
  end

  def pred402(t1) do
    x1 = LogicElixir.VarBuilder.gen_var()
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
                |> Stream.flat_map(fn th2 ->
                  (fn th1 ->
                     (fn th -> unify_gen(th, {:var, x1}, {:ground, 4}) end).(th1)
                     |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
                   end).(th2)
                end)
              end
            ]
            |> Stream.flat_map(fn f -> f.(th) end)
          end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1]))
    end
  end

  def pred41() do
    nil
    y1 = LogicElixir.VarBuilder.gen_var()

    fn th1 ->
      th2 = Map.merge(th1, Map.new([]))

      (fn th1 ->
         (fn th -> unify_gen(th, [ground: 1, ground: 2], var: y1) end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [y1]))
    end
  end

  def is_ordered(t1) do
    x1 = LogicElixir.VarBuilder.gen_var()

    (
      y1 = LogicElixir.VarBuilder.gen_var()
      y2 = LogicElixir.VarBuilder.gen_var()
      y3 = LogicElixir.VarBuilder.gen_var()
    )

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}]))

      (fn th1 ->
         (fn th ->
            [
              fn th1 ->
                (fn th -> unify_gen(th, {:var, x1}, []) end).(th1)
                |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
              end,
              fn th1 ->
                (fn th -> unify_gen(th, {:var, x1}, [{:var, y1} | []]) end).(th1)
                |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
              end,
              fn th1 ->
                (fn th -> unify_gen(th, {:var, x1}, [{:var, y1} | [{:var, y2} | {:var, y3}]]) end).(
                  th1
                )
                |> Stream.flat_map(fn th2 ->
                  (fn th1 ->
                     (fn th ->
                        check_b(
                          th,
                          groundify(
                            th,
                            (
                              (
                                x1 = groundify(th, {:var, y1})
                                x2 = groundify(th, {:var, y2})
                              )

                              {:ground, x1 <= x2}
                            )
                          )
                        )
                      end).(th1)
                     |> Stream.flat_map(fn th2 ->
                       (fn th1 ->
                          (fn th -> is_ordered([{:var, y2} | {:var, y3}]).(th) end).(th1)
                          |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
                        end).(th2)
                     end)
                   end).(th2)
                end)
              end
            ]
            |> Stream.flat_map(fn f -> f.(th) end)
          end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1, y1, y2, y3]))
    end
  end

  def append(t1, t2, t3) do
    (
      x1 = LogicElixir.VarBuilder.gen_var()
      x2 = LogicElixir.VarBuilder.gen_var()
      x3 = LogicElixir.VarBuilder.gen_var()
    )

    (
      y1 = LogicElixir.VarBuilder.gen_var()
      y2 = LogicElixir.VarBuilder.gen_var()
      y3 = LogicElixir.VarBuilder.gen_var()
    )

    fn th1 ->
      th2 = Map.merge(th1, Map.new([{x1, t1}, {x2, t2}, {x3, t3}]))

      (fn th1 ->
         (fn th ->
            [
              fn th1 ->
                (fn th -> unify_gen(th, {:var, x1}, []) end).(th1)
                |> Stream.flat_map(fn th2 ->
                  (fn th1 ->
                     (fn th -> unify_gen(th, {:var, x2}, {:var, x3}) end).(th1)
                     |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
                   end).(th2)
                end)
              end,
              fn th1 ->
                (fn th -> unify_gen(th, {:var, x1}, [{:var, y1} | {:var, y2}]) end).(th1)
                |> Stream.flat_map(fn th2 ->
                  (fn th1 ->
                     (fn th -> unify_gen(th, {:var, x3}, [{:var, y1} | {:var, y3}]) end).(th1)
                     |> Stream.flat_map(fn th2 ->
                       (fn th1 ->
                          (fn th -> append({:var, y2}, {:var, x2}, {:var, y3}).(th) end).(th1)
                          |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
                        end).(th2)
                     end)
                   end).(th2)
                end)
              end
            ]
            |> Stream.flat_map(fn f -> f.(th) end)
          end).(th1)
         |> Stream.flat_map(fn th2 -> (fn th -> [th] end).(th2) end)
       end).(th2)
      |> Stream.map(&Map.drop(&1, [x1, x2, x3, y1, y2, y3]))
    end
  end
end

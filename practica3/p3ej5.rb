require_relative '../extensions/array'

def prod_r(required_units, cost_per_unit, fixed_cost, stock_cost, prod_interval)

  # caso base: el ultimo mes de produccion
  if required_units.size == 1
    return [cost_to_produce(required_units.first,
                           cost_per_unit.first,
                           fixed_cost),
                           [required_units.first]]
  end

  # trato de producir todo en el mes actual
  chosen_units = required_units.sum
  # cuantas unidades me quedarían como stock
  remaining_units = chosen_units - required_units.first
  # cuál es el costo de producir esas
  better_prod_cost = nil

  # mientras la cantidad que intente producir en el mes actual
  # sea mayor o igual a la requerida
  while chosen_units >= required_units.first
    g = calculate_next_required_units(remaining_units, required_units.tail)
    e = 0
    g[1].each_with_index { |x, i| e += x * (i + 1) * stock_cost }
    rec = prod_r(
      g[0],
      cost_per_unit.tail,
      fixed_cost,
      stock_cost,
      prod_interval
    )
    current_prod = cost_to_produce(chosen_units, cost_per_unit.first, fixed_cost) + e
    if better_prod_cost.nil?
      better_prod_cost = current_prod
      better_prod = chosen_units
    end

    total_prod_cost_with_current_chosen_units = current_prod + rec[0] + e
    if total_prod_cost_with_current_chosen_units < better_prod_cost
      # la mejor produccion hasta el momento
      better_prod_cost = total_prod_cost_with_current_chosen_units
      better_prod = chosen_units
    end

    # trato de elegir menos unidades
    chosen_units -= prod_interval
    remaining_units = chosen_units - required_units.first
  end

  [better_prod_cost, [better_prod] + rec[1]]
end

def cost_to_produce(units, cost_per_unit, fixed_cost)
  calculated_fixed_cost = units == 0 ? 0 : fixed_cost
  units * cost_per_unit + calculated_fixed_cost
end

def calculate_next_required_units(remaining_units, required_units)
  new_required_units = []
  consumed_units = []
  required_units.each do |req|
    if remaining_units - req > 0
      new_required_units << 0
      consumed_units << req
      remaining_units = remaining_units - req
    else
      new_required_units << req - remaining_units
      consumed_units << remaining_units
      remaining_units = 0
    end
  end
  [new_required_units, consumed_units]
end

def prod_dp(required_units, cost_per_unit, fixed_cost, stock_cost, prod_interval)
  p = Array.new required_units.length
  l = ((required_units.sum / prod_interval) + 1)
  required_units.length.times { |i| p[i] = Array.new l }

  # producciones posibles en el primer mes
  for j in (required_units[0] / prod_interval)..l-1
    p[0][j] = cost_to_produce(j * prod_interval, cost_per_unit[0], fixed_cost)
  end

  required_so_far = required_units[0]
  for i in 1..required_units.length-1
    # para comenzar en el lugar correcto de la matriz (antes implicaría una producción que no es posible)
    for j in ((required_units[i] + required_so_far) / prod_interval)..l-1
      puts i, j
      p[i][j] = cost_to_produce(j * prod_interval, cost_per_unit[0], fixed_cost)
    end
    required_so_far += required_units[i]
  end

  puts p.to_s
end

# puts prod_r([200, 300, 300], [10, 10, 200], 250, 1.5, 100).to_s
puts prod_dp([200, 300, 300], [10, 10, 200], 250, 1.5, 100).to_s

# ((400*10) + 250 + (200*1,5)) + ((200*10) + 250 + 0) + ((200*12) + 250 + 0)

# puts calculate_next_required_units(300, [200, 300, 300]).to_s # 0, 200

# puts prod_r([200], [10], [100], [100])

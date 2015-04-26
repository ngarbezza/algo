class Array
  def tail
    drop 1
  end

  def sum
    inject :+
  end

  def without_elem_at(an_index)
    clone.tap { |t| t.delete_at an_index }
  end

  def add_first(an_element)
    unshift an_element
  end

  def add_last(an_element)
    self << an_element
  end
end

class PQElem
  include Comparable

  attr_accessor :obj, :priority

  def initialize(obj, priority)
    @obj, @priority = obj, priority
  end

  def <=>(other)
    @priority <=> other.priority
  end

  def ==(other)
    @priority == other.priority && @obj == other.obj
  end
end

class PriorityQueue
  # implementación sencilla de priority queue. Asume que
  # conceptualmente todas sus operaciones son O(log n)

  def initialize
    @elements = []
  end

  def <<(element)
    @elements << element
  end

  def pop
    last_element_index = @elements.size - 1
    @elements.sort!
    @elements.delete_at(last_element_index)
  end

  def find(predicate, if_found, if_not_found)
    for i in 0..@elements.size-1
      return if_found.call(@elements[i]) if predicate.call(@elements[i])
    end
    if_not_found.call
  end

  def remove(element)
    @elements.delete(element)
  end

  def to_s
    out = ''
    @elements.each do |element|
      out += "#{element.priority}: #{element.obj}\n"
    end
    out
  end
end

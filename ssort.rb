def ssort(xs)
  copy = xs
  ordered = []
  copy.each do |elemm|
    smaller = elemm
    copy.each do |elem|
      if (elem < smaller)
        smaller = elem
      end
    end
    copy.delete(elemm)
  end
  ordered
end

def median(xs)
  ordered = ssort(xs)
  return ordered[ordered.length / 2]
end

xs = [1,4,3,7,2,7,3]
puts ssort(xs)
puts median(xs)

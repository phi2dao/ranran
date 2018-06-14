module Ranran
  class Bucket
    def zipf s
      dup.zipf! s
    end

    def zipf! s
      sum = 1.upto(length).inject(0) do |acc, n|
        acc + 1.0 / n ** s
      end
      @items.to_a.each_with_index do |(item, weight), i|
        @items[item] = (1.0 / (i + 1) ** s) / sum
      end
      @weight = 1.0
      self
    end
  end
end
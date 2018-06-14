module Ranran
  class Bucket
    attr_reader :weight

    def initialize
      @items = {}
      @weight = 0
    end

    def empty?
      @items.empty?
    end

    def length
      @items.length
    end

    def items
      @items.to_a
    end

    def [] item
      @items[item]
    end

    def []= item, weight
      raise TypeError, "#{weight} is not numeric" unless weight.is_a? Numeric
      @weight -= @items[item] if @items.key? item
      @items[item] = weight
      @weight += weight
      [item, weight]
    end

    def add item, weight
      raise TypeError, "#{weight} is not numeric" unless weight.is_a? Numeric
      if @items.key? item
        @items[item] += weight
      else
        @items[item] = weight
      end
      @weight += weight
      self
    end

    def delete item
      weight = @items.delete item
      @weight -= weight
      [item, weight]
    end

    def choose n = nil
      if n
        n.times.map { weighted_random }
      else
        weighted_random
      end
    end

    def take n = nil
      if n
        dup.take! n
      else
        weighted_random
      end
    end

    def take! n = nil
      if n
        n.times.map { take! }
      else
        return nil if empty?
        taken = weighted_random
        delete taken
        taken
      end
    end

    def dup
      new_bucket = self.class.new
      @items.each_pair do |item, weight|
        new_bucket.add item, weight
      end
      new_bucket
    end

    def == o
      o.class == self.class && o.items == self.items
    end

    alias :eql? :==

    def hash
      @items.hash
    end

    private
    def weighted_random
      return nil if empty?
      goal = rand * @weight
      # current = 0
      # @items.each_pair do |item, weight|
      #   current += weight
      #   return item if goal < current
      # end
      @items.inject(0) do |acc, (item, weight)|
        return item if goal < acc + weight
        acc + weight
      end
    end
  end
end
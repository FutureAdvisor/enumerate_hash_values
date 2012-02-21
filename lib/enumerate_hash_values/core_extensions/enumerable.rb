module Enumerable # :nodoc:

  # Wraps the common pattern of doing:
  # 
  #   enumerable.inject({}) do |hash, item|
  #     some_key        = item.key
  #     some_value      = item.value
  #     hash[some_key]  = some_value
  #     hash
  #   end
  #
  # Using <tt>collect_to_hash</tt> instead:
  #
  #   enumerable.collect_to_hash do |item|
  #     some_key = item.key
  #     some_value = item.value
  #     [some_key, some_value]
  #   end
  #
  # Examples:
  #
  #   (1..3).collect_to_hash { |number| [number, number * 10] } # => { 1 => 10, 2 = > 20, 3 => 30 }
  #   %w(a b c).map_to_hash { |letter| [letter, letter[0]] }    # => { 'a' => 97, 'b' => 98, 'c' => 99 }
  #
  # Aliases <tt>map_to_hash</tt>
  def collect_to_hash(hash_class = Hash)
    raise ArguementError.new("#{hash_class} is not a Hash") unless hash_class.ancestors.include?(Hash)

    inject(hash_class.new) do |hash, item|
      key, value = yield(item)
      hash[key] = value
      hash
    end
  end
  alias_method :map_to_hash, :collect_to_hash

  # Similar to <tt>collect_to_hash</tt>, but the specified block only needs to
  # return the hash value for each enumerated item. The items themselves will
  # serve as the hash keys.
  #
  #   (1..3).collect_to_hash_values { |number| number * 10 }  # => { 1 => 10, 2 = > 20, 3 => 30 }
  #   %w(a b c).map_to_hash_values(&:to_sym)                  # => { 'a' => :a, 'b' => :b, 'c' => :c }
  #
  # Aliases <tt>map_to_hash_values</tt>
  def collect_to_hash_values(hash_class = Hash)
    collect_to_hash(hash_class) { |item| [item, yield(item)] }
  end
  alias_method :map_to_hash_values, :collect_to_hash_values

end

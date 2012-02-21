class Hash # :nodoc:

  # Define values and values_with_keys versions of each method.
  {
    'values'            => 'yield(value)',
    'values_with_keys'  => 'yield(key, value)'
  }.each do |method_suffix, yield_call|

    class_eval <<-ENUMERATE_ON_VALUES_METHODS, __FILE__, __LINE__ + 1

      def collect_#{method_suffix}
        inject_into_empty do |hash, (key, value)|
          hash[key] = #{yield_call}
          hash
        end
      end
      alias_method :map_#{method_suffix}, :collect_#{method_suffix}

      def collect_#{method_suffix}!
        each do |key, value|
          self[key] = #{yield_call}
        end
        self
      end
      alias_method :map_#{method_suffix}!, :collect_#{method_suffix}!

      def reject_#{method_suffix}
        inject_into_empty do |hash, (key, value)|
          hash[key] = value unless #{yield_call}
          hash
        end
      end

      def reject_#{method_suffix}!
        delete_if { |key, value| #{yield_call} }
      end

      def select_#{method_suffix}
        reject_values_with_keys { |key, value| !#{yield_call} }
      end

      def select_#{method_suffix}!
        reject_values_with_keys! { |key, value| !#{yield_call} }
      end

    ENUMERATE_ON_VALUES_METHODS

  end

  # Shortcut to perform a shallow copy of the hash to a new instance.
  def copy
    collect_values { |value| value }
  end

  # Copy any traits (such as defaults) from the specified hash.
  def copy_traits!(hash)
    self.default = hash.default

    # Unfortunately, we can only transfer Hash#default_proc in Ruby 1.9 because
    # Hash#default_proc= is only defined in Ruby 1.9.
    self.default_proc = hash.default_proc if respond_to?(:default_proc=)

    self
  end

  # Shortcut to inject into an empty hash.
  def inject_into_empty(hash_class = self.class, options = {})
    raise ArgumentError.new("#{hash_class} is not a Hash") unless hash_class.ancestors.include?(Hash)

    # If not explicitly specified, copy traits into the new hash if it is of
    # the same class.
    copy_traits = options.has_key?(:copy_traits) ? options[:copy_traits] : (hash_class == self.class)

    new_hash_options = {}
    new_hash_options[:traits_from] = self if copy_traits
    new_hash = hash_class.new_empty(new_hash_options)

    inject(new_hash) do |hash, key_value_pair|
      yield hash, key_value_pair
    end
  end

  class << self

    def new_empty(options = {})
      new_hash = allocate
      new_hash.copy_traits!(options[:traits_from]) if options[:traits_from]
      new_hash
    end

  end

end

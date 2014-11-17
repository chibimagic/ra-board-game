class Sun
  attr_accessor :value, :used

  def initialize(value, used)
    raise 'Invalid value' unless (1..16).include?(value)
    raise 'Invalid used' unless [true, false].include?(used)

    @value = value
    @used = used
  end

  def self.create_new(value)
    new(value, false)
  end

  def use
    if @used
      raise 'Already used'
    end

    @used = true
  end

  def reset
    @used = false
  end
end

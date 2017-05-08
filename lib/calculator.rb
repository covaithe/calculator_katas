class Calculator
  def self.add input
    new(input).add
  end

  attr_accessor :input

  def initialize input
    self.input = input
  end

  def add
    validate
    addends.inject 0, :+
  end

  def validate
    negatives = addends.select {|x| x < 0}
    raise "negatives not allowed: #{negatives}.join(', ')" if negatives.any?
  end

  def addends
    @addends ||= input_body.split(splitter).map(&:to_i).reject{|x| x > 1000}
  end

  def splitter
    Regexp.union delimiters
  end

  def delimiters
    [",", "\n", custom_delimiter].compact
  end

  def input_body
    return input unless has_custom_delimiter?
    i = input.index("\n") + 1
    input[i..-1]
  end

  def custom_delimiter
    return nil unless has_custom_delimiter?
    return input[2] unless input =~ /\[(.*)\]/
    $1
  end

  def has_custom_delimiter?
    input.start_with? "//"
  end

end

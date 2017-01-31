class Calculator

  def self.add input
    Parser.new(input).addends.inject 0, :+
  end
end

class Parser

  attr_accessor :input

  def initialize input
    self.input = input
    validate
  end

  def addends
    splitter = Regexp.union delimiters
    input_body.split(splitter).map(&:to_i).reject{|x| x > 1000}
  end

  def input_body
    if has_custom_delimiter?
      return input.split("\n").last
    end
    input
  end

  def delimiters
    [",", "\n", custom_delimiters].flatten.compact
  end

  def custom_delimiters
    return nil unless has_custom_delimiter?
    if input =~ /\[(.*)\]/
      $1.split "]["
    else
      input[2]
    end
  end

  def has_custom_delimiter?
    input.start_with? "//"
  end

  def validate
    negatives = addends.select{ |x| x < 0 }
    raise "Negatives not allowed: #{negatives.join(', ')}" if negatives.any?
  end
end

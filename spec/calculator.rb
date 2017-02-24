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

  def validate
    negatives = addends.select{|x| x < 0}
    raise "Negatives not allowed: #{negatives.join(", ")}" if negatives.any? 
  end

  def addends
    input_body.split(splitter).map(&:to_i).reject{|x| x > 1000}
  end

  def splitter
    Regexp.union delimiters
  end

  def delimiters
    [",", "\n", custom_delimiter].compact.flatten
  end

  def input_body
    return input unless input.start_with? "//"
    i = input.index("\n") + 1
    input[i..-1]
  end

  def custom_delimiter
    return nil unless input.start_with? "//"
    if input =~ /\[(.*)\]/
      $1.split("][")
    else
      input[2]
    end
  end
end

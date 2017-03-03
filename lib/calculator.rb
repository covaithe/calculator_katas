class Calculator

  def self.add input
    Parser.build(input).addends.inject 0, :+
  end
end

class Parser

  attr_accessor :input

  def initialize input
    self.input = input
    validate
  end

  def self.build input
    return LongDelimiterParser.new(input) if input.start_with? "//["
    return CustomDelimiterParser.new(input) if input.start_with? "//"
    DefaultParser.new(input)
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
    raise "derived classes must implement this"
  end

  def input_body
    raise "derived classes must implement this"
  end
end

class DefaultParser < Parser
  def delimiters
    [",", "\n"]
  end

  def input_body
    input
  end
end

class CustomDelimiterParser < Parser
  def delimiters
    [",", "\n", custom_delimiter]
  end

  def custom_delimiter
    input[2]
  end

  def input_body
    input[4..-1]
  end
end

class LongDelimiterParser < Parser


  def delimiters
    [",", "\n", custom_delimiter].compact.flatten
  end

  def custom_delimiter
    expression = /\[(.*)\]/
    stuff = input.match(expression)[1]
    stuff.split("][")
  end

  def input_body
    i = input.index("\n") + 1
    input[i..-1]
  end
end

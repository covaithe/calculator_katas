class Calculator

  def self.add input
    parser = Parser.build(input)
    parser.validate
    parser.addends.inject 0, :+
  end
end

class Parser

  attr_accessor :input

  def self.build input
    return LongDelimiterParser.new(input) if input.start_with? "//["
    return CustomDelimiterParser.new(input) if input.start_with? "//"
    DefaultParser.new(input)
  end

  def initialize input
    self.input = input
  end

  def validate
    raise "Negative numbers not allowed" if addends.any?{|x| x < 0}
  end

  def addends
    input_body.split(splitter).map(&:to_i)
  end

  def splitter
    Regexp.union delimiters
  end

  def delimiters
    [ ",", "\n", extra_delimiters].flatten
  end

  def extra_delimiters
    raise "derived classes must implement this"
  end

  def input_body
    raise "derived classes must implement this"
  end

end

class DefaultParser < Parser
  def extra_delimiters
    []
  end

  def input_body
    input
  end
end

class CustomDelimiterParser < Parser
  def extra_delimiters
    input[2]
  end

  def input_body
    input[4..-1]
  end
end

class LongDelimiterParser < Parser
  def extra_delimiters
    md = input.match /\[(.*)\]/
    md[1].split "]["
  end

  def input_body
    i = input.index("\n") + 1
    input[i..-1]
  end
end

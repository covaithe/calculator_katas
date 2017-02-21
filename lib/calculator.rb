class Calculator

  def self.add input
    Parser.build(input).addends.inject 0, :+
  end
end

class Parser

  def self.build input
    if input.start_with? "//"
      return LongDelimiterParser.new(input) if input.include? "["
      return CustomDelimiterParser.new(input)
    end
    DefaultParser.new(input)
  end

  def addends
    input_body.split(splitter).map(&:to_i)
  end

  def splitter
    raise "derived classes must implement this"
  end

  def input_body
    raise "derived classes must implement this"
  end

  private

  attr_accessor :input

  def initialize input
    self.input = input
  end
end

class DefaultParser < Parser
  def splitter
    Regexp.union ",", "\n"
  end

  def input_body
    input
  end
end

class CustomDelimiterParser < Parser
  def splitter
    input[2]
  end

  def input_body
    input[4..-1]
  end
end

class LongDelimiterParser < Parser
  def splitter
    input.match(/\[(.*)\]/)[1]
  end

  def input_body
    i = input.index "\n"
    input[i..-1]
  end
end

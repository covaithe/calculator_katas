require 'calculator'

RSpec.describe Calculator do

  it "should be 0 given empty string" do
    expect(Calculator.add("")).to eq 0
  end

  it "should convert a single number to int" do
    expect("123").to sum_to 123
  end

  it "should add two numbers" do
    expect("1,2").to sum_to 3
  end

  it "should add many numbers" do
    expect("1,2,3,4,5").to sum_to 15
  end

  it "should allow newline as delimiter" do
    expect("1\n2").to sum_to 3
  end

  it "should handle custom delimiters" do
    expect("//;\n1;2").to parse_addends 1,2
    expect("//;\n1;2").to sum_to 3
  end

  it "should reject negative arguments" do
    expect{ Calculator.add("1,-2") }.to raise_error /negatives not allowed/
  end

  it "should list all the bad negative arguments in the error msg" do
    expect{ Calculator.add("-3,1,-2") }.to raise_error /-3, -2/
  end

  it "should ignore large arguments" do
    expect("1,2,1000,1001").to parse_addends 1,2,1000
    expect("1,2,1000,1001").to sum_to 1003
  end

  it "should handle long custom delimiters" do
    expect("//[***]\n1***2").to have_delimiter "***"
    expect("//[***]\n1***2").to parse_addends 1,2
    expect("//[***]\n1***2").to sum_to 3
  end

  RSpec::Matchers.define :have_delimiter do |delimiter|
    match do |subject|
      @delimiters = Calculator.new(subject).delimiters
      @delimiters.include? delimiter
    end

    failure_message do |subject|
      "expected #{subject.inspect} to have delimiter #{delimiter.inspect} but got #{@delimiters}"
    end
  end

  RSpec::Matchers.define :parse_addends do |*expected|
    match do |subject|
      @addends = Calculator.new(subject).addends
      @addends == expected
    end

    failure_message do |subject|
      "expected #{subject.inspect}\n" +
      "   to have addends #{expected}\n" +
      "         but found #{@addends}"
    end
  end

  RSpec::Matchers.define :sum_to do |expected|
    match do |subject|
      @sum = Calculator.add(subject)
      @sum == expected
    end

    failure_message do |subject|
      "expected #{subject.inspect} to sum to #{expected} but got #{@sum.inspect}"
    end
  end
end

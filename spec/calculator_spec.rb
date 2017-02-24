require 'calculator'

RSpec.describe Calculator do

  it "should add whatever addends the parser finds" do
    parser = double(Parser, addends: [1,2,3])
    expect(Parser).to receive(:build).with("foo").and_return parser
    expect(Calculator.add("foo")).to eq 1+2+3
  end

  def self.it_should_add_to expected
    it "should add to #{expected}" do
      expect(Calculator.add(input)).to eq expected
    end
  end

  def self.it_should_parse_the_addends_as *expected
    it "should parse the arguments as #{expected}" do
      expect(Parser.build(input).addends).to eq expected.flatten
    end
  end

  def self.it_should_build_a expected
    it "should build a #{expected}" do
      expect(Parser.build(input)).to be_a expected
    end
  end

  context "when given empty string" do
    let(:input) {""}
    it_should_add_to 0
    it_should_parse_the_addends_as []
  end

  context "given a single number" do
    let(:input) {"1"}
    it_should_add_to 1
    it_should_parse_the_addends_as 1
  end

  context "given many numbers" do
    let(:input) {"1,2,3,4,5"}
    it_should_add_to 15
    it_should_parse_the_addends_as 1,2,3,4,5
  end

  context "with newline as a delimiter" do
    let(:input) {"1\n2"}
    it_should_add_to 3
    it_should_parse_the_addends_as 1,2
  end

  context "with a custom delimiter" do
    let(:input) {"//+\n1+2"}
    it_should_add_to 3
    it_should_parse_the_addends_as 1,2
    it_should_build_a CustomDelimiterParser
  end

  context "when given negative numbers" do
    let(:input) {"-1,2,-3"}

    it "should raise an error" do
      expect{ Parser.build(input) }.to raise_error /Negatives not allowed/
    end

    it "should include all negative numbers in the message" do
      expect{ Parser.build(input) }.to raise_error /-1, -3/
    end
  end

  context "when given numbers that are too large" do
    let(:input) {"1,2,1000,1001"}

    it_should_add_to 1003
    it_should_parse_the_addends_as 1,2,1000
  end

  context "with a long custom delimiter" do
    let(:input) {"//[***]\n1***2"}
    it_should_add_to 3
    it_should_parse_the_addends_as 1,2
    it_should_build_a LongDelimiterParser
  end

  context "with multiple custom delimiter" do
    let(:input) {"//[***][++][-]\n1***2++3-4"}
    it_should_add_to 10
    it_should_parse_the_addends_as 1,2,3,4
    it_should_build_a LongDelimiterParser
  end

  
end

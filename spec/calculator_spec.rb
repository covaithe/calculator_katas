require 'calculator'


RSpec.describe Calculator do

  it "should be 0 given empty string" do
    expect(Calculator.add("")).to eq 0
  end

  it "should add whatever the parser returns" do
    allow_any_instance_of(Parser).to receive(:addends).and_return([1,2,3])
    expect(Calculator.add("foo")).to eq 1+2+3
  end

  let(:addends) { Parser.new(input).addends }
  let(:sum) { Calculator.add(input) }

  def self.sum_should_be expected
    it "should add to #{expected}" do
      expect(sum).to eq expected
    end
  end

  def self.addends_should_be expected
    it "should parse to these addends: #{expected}" do
      expect(addends).to eq expected
    end
  end

  def self.delimiters_should_be *expected
    it "should use these delimiters: #{expected}" do
      expect(Parser.new(input).delimiters).to eq expected
    end
  end

  def self.input_body_should_be expected
    it "should get the input body: '#{expected}'" do
      expect(Parser.new(input).input_body).to eq expected
    end
  end

  context "when given empty string" do
    let(:input) { "" }

    sum_should_be 0
    addends_should_be []
  end

  context "given a single number" do
    let(:input) { "1" }
    sum_should_be 1
    addends_should_be [1]
  end

  context "given two numbers" do
    let(:input) { "1,2" }

    sum_should_be 3
    addends_should_be [1,2]
  end

  context "given many numbers" do
    let(:input) { "1,2,3,4,5" }

    sum_should_be 15
    addends_should_be [1,2,3,4,5]
  end

  context "given newline as delimiter" do
    let(:input) { "1\n2" }

    sum_should_be 3
    addends_should_be [1,2]
    delimiters_should_be ",", "\n"
  end

  context "with a custom delimiter" do
    let(:input) { "//;\n1;2" }

    sum_should_be 3
    addends_should_be [1,2]
    delimiters_should_be ",", "\n", ";"
  end

  context "with negative numbers in the input" do
    it "should raise an error" do
      expect{Parser.new("1,-2") }.to raise_error /Negatives not allowed/
    end

    it "should list all negative args in the error message" do
      expect { Parser.new("-1,2,-3") }.to raise_error /-1, -3/
    end
  end

  context "given numbers above 1000" do
    let(:input) { "1,2,1000,1001" }

    sum_should_be 1003
    addends_should_be [1,2,1000]
  end

  context "with a long custom delimiter" do
    let(:input) { "//[***]\n1***2" }
    sum_should_be 3
    addends_should_be [1,2]
    delimiters_should_be ",", "\n", "***"
    input_body_should_be "1***2"
  end

  context "with multiple custom delimiter" do
    let(:input) { "//[**][+][---]\n1**2+3---4" }
    sum_should_be 1+2+3+4
    addends_should_be [1,2,3,4]
    delimiters_should_be ",", "\n", "**", "+", "---"
    input_body_should_be "1**2+3---4"
  end

end

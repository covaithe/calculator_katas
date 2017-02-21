require 'calculator'

RSpec.describe Calculator do

  it "should be 0 given empty string" do
    expect(Calculator.add("")).to eq 0
  end

  it "should add whatever the parser gives it" do
    parser = double(addends: [1,2,3])
    allow(Parser).to receive(:build).with("foo").and_return parser
    expect(Calculator.add("foo")).to eq 1+2+3
  end

  describe Parser do
    it "should convert a single number to int" do
      expect(Parser.build("1").addends).to eq [1]
    end

    it "should parse two numbers comma separated" do
      expect(Parser.build("1,2").addends).to eq [1,2]
    end

    it "should handle newlines as delimiter" do
      expect(Parser.build("1\n2").addends).to eq [1,2]
    end

    it "should handle custom delimiters" do
      expect(Parser.build("//;\n1;2").addends).to eq [1,2]
      expect(Parser.build("//+\n1+2").addends).to eq [1,2]
    end

    it "should handle long custom delimiters" do
      expect(Parser.build("//[***]\n1***2").addends).to eq [1,2]
    end

  end
end

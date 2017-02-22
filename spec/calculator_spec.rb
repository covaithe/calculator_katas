require 'calculator'

RSpec.describe Calculator do

  it "should add whatever the parser gives it" do
    parser = double(validate: true, addends: [1,2,3,4])
    expect(Parser).to receive(:new).with("foo").and_return parser
    expect(Calculator.add("foo")).to eq 1+2+3+4
  end
  
  it "should validate" do
    expect_any_instance_of(Parser).to receive(:validate)
    Calculator.add("foo")
  end

  describe Parser do

    def self.it_should_parse_as *expected
      it "should parse to '#{expected}'" do
        expect(Parser.build(input).addends).to eq expected.flatten
      end
    end

    def self.it_should_build_a expected_class
      it "should build a '#{expected_class}'" do
        expect(Parser.build(input)).to be_a expected_class
      end
    end

    context "given an empty string" do
      let(:input) { "" }
      it_should_parse_as []
      it_should_build_a DefaultParser
    end

    context "given a single number" do
      let(:input) { "1" }
      it_should_parse_as 1
      it_should_build_a DefaultParser
    end

    context "given many numbers" do
      let(:input) { "1,2,3,4,5" }
      it_should_parse_as 1,2,3,4,5
      it_should_build_a DefaultParser
    end

    context "with newline as delimiter" do
      let(:input) { "1\n2" }
      it_should_parse_as 1,2
      it_should_build_a DefaultParser
    end

    [";", "+"].each do |delim|
      context "with custom delimiter: #{delim}" do
        let(:input) { "//#{delim}\n1#{delim}2" }
        it_should_parse_as 1,2
        it_should_build_a CustomDelimiterParser
      end
    end

    context "with a long delimiter" do
      let(:input) { "//[***]\n1***2" }
      it_should_parse_as 1,2
      it_should_build_a LongDelimiterParser
    end

    context "with multiple custom delimiters" do
      let(:input) { "//[+][;;][***]\n1***2+3;;4" }
      it_should_parse_as 1,2,3,4
      it_should_build_a LongDelimiterParser
    end

    describe "validate" do
      context "with normal input" do
        it "should not raise" do
          expect{ Parser.build("1,2").validate }.not_to raise_error
        end
      end

      context "with negative numbers in the input" do
        let(:input) { "-1,2,-3" }
        it "should complain" do
          expect{ Parser.build(input).validate }.to raise_error /Negative numbers not allowed/
        end
      end
    end
  end

  describe CustomDelimiterParser do
    let(:input) { "//;\n1;2" }

    it "should know what the extra delimiter is" do
      expect(CustomDelimiterParser.new(input).extra_delimiters).to eq ";"
    end

    it "should know what the body of the input is" do
      expect(CustomDelimiterParser.new(input).input_body).to eq "1;2"
    end
  end

  describe LongDelimiterParser do
    subject { LongDelimiterParser.new(input) }

    context "with a single delimiter" do
      let(:input) { "//[+++]\n1+++3" }

      it "should know what the extra delimiter is" do
        expect(subject.extra_delimiters).to eq [ "+++" ]
      end

      it "should know what the body of the input is" do
        expect(subject.input_body).to eq "1+++3"
      end
    end

    context "with multiple delimiters" do
      let(:input) { "//[+++][**]\n2**1+++3" }

      it "should know what the extra delimiter is" do
        expect(subject.extra_delimiters).to eq [ "+++", "**" ]
      end

      it "should know what the body of the input is" do
        expect(subject.input_body).to eq "2**1+++3"
      end

    end
  end

end

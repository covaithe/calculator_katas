require 'calculator'

RSpec.describe Calculator do

  it "should return 0 for empty string " do
    expect(Calculator.add("")).to eq 0
  end

  it "given one number should return it" do
    expect(Calculator.add("1")).to eq 1
    expect(Calculator.add("2")).to eq 2
  end

  it "given two numbers, add them" do
    expect(Calculator.add("1,2")).to eq 3
    expect(Calculator.add("1,6")).to eq 7
    expect(Calculator.add("3,6")).to eq 9
    expect(Calculator.add("3,4")).to eq 7
  end

end

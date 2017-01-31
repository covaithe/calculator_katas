2017-01-31

Today's implementation is a fairly standard parser class version, but the
interesting part is in the tests.  I wanted to try using Calculator.add(...) 
assertions as acceptance tests, and tests against the parser as "unit" tests
of the implementation.  I grouped them into contexts by feature, like so:

```
context "when given two numbers" do
  let(:input) { "1,2" }

  it "should add them" do
    expect(Calculator.add(input)).to eq 3
  end

  it "should parse the arguments correctly" do
    expect(Parser.new(input).addends).to eq [1,2]
  end
end
```

I quickly ran into duplication in those tests: the tests for many numbers is
very similar to the tests for 2 numbers.  Instead of just plowing ahead, I 
decided to see if I could extract the test generation itself out to a 
utility method.  After a few failed attempts, I ended up with something
like this:

```
def self.sum_should_be expected
  it "should add to #{expected}" do
    expect(Calculator.add(input)).to eq expected
  end
end

def self.addends_should_be expected
  it "should parse to these addends: #{expected}" do
    expect(Parser.new(input).addends).to eq expected
  end
end

context "when given two numbers" do
  let(:input) { "1,2" }

  sum_should_be 3
  addends_should_be [1,2]
end
```

I have to confess I don't fully understand how this works.  I understand 
using a class method to generate instance methods; that's how RSpec itself
works.  I even understand why late binding of input lets me specify
the input inside the contexts, but use it in the generated instance methods.
What I don't understand is how the value of expected gets into the 
expectation.  I would have expected that the code inside the it blocks 
wouldn't get evaluated at all until RSpec runs an individual test, but then
how is the value of expected preserved?  Is there some kind of closure-like
thing going on in the class definition?  I'm not sure, and thinking about it 
hurts my tiny brain just a little.  It does work though; the expectation
value is preserved *somehow*, which is good enough for me right now.

I find this style interesting because it answers several objections I've
had in the past to this method of approaching the testing.  It's nice to be
able to have both high-level assertions on the outer interface of the 
System Under Test (SUT), as well as low-level assertions on pieces of the
implementation.  High-level assertions prove correctness and support safe
refactoring, and low-level provide detailed information about what's wrong
in case of a problem, and support the incremental TDD patterns that lead to
good flow and an enjoyable development experience.  It's nice to have them 
both, but omg it's so verbose.  All those tests not only take forever to type
into your editor -- destroying flow -- but they also obfuscate the spec file,
making it hard to read and hard to reason about.  But these helper 
methods for generating extremely terse assertions *on a context* really cut
down on the verbosity.  It feels more like a custom DSL for describing
the functionality of this particular implementation stack than traditional
rspec testing.  You get strong high level assertions, good low-level error
messages, *and* a nice clean readable spec file.  What could be better?

Well, it is a little bit magic.  As metaprogramming goes, this is pretty
vanilla.  It's localized to just this outer describe block.  It's neither
very long or very dense code.  Still...  There is always a tradeoff between
terseness and clarity.  Would a junior developer on my team be able to read
and work with this code?  Will *I* remember how it works if I revisit this
in six months, or will future-me curse present-me for making him work hard
to understand these tests?  Every developer, and every team, will have to 
work out for themselves where to draw the line on how much cleverness is 
too much.  For me, right now, this seems like an acceptable level of
cleverness, and I'm going to hang on to this trick.  And hope future-me
doesn't come to regret it. 


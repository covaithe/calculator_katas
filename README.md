2017-05-08

Today's version is exploring RSpec custom matchers.  

The exercise I was focusing on with this iteration of the kata is having descriptive 
tests.  I mean two things by that.  

First, the tests should be easily readable and serve as clear documentation of 
the SUT, so that when I inevitably forget all about this code and come back to it,
the tests can help me figure out how the system behaves, and in particular I 
shouldn't need to understand the implentation very much in order to figure the 
tests out.  

Second, I want helpful error messages.  I've done this kata a lot of times, 
but even so when I'm working on, say, custom delimiters, and I get a 
test failure message like "Expected 3 but got 1", it sometimes takes me a 
bit of thinking to figure out what happened and how to proceed.  The message 
is true, but not very helpful.  In this kata, that's not a big deal, but in 
real-life development that kind of unhelpful error message can be very 
frustrating and time-consuming to understand.  

This implementation tries to use rspec custom matchers to help provide clear
error messages.  Here are some pros and cons.

Pros:
  * Pretty good test failure messages.  This was my main goal, so I'm glad that
    I was able to achieve it with this testing strategy.
  * Having complex assertions handy in a nicely-packaged form makes them easier to use,
    and I find I'm more likely to make these more powerful assertions more often. 
    I think that's a win.  In a larger application with a more complex domain model,
    having a library of powerful domain-specific assertions could be a big win, over time.

Cons:
  * I always have to look up how to write RSpec matchers.  No matter how often I try,
    I've yet to successfully do this thing without referring to documentation, which 
    slows me down and breaks flow.  Might just be me, though.
  * even after absorbing the documentation -- again -- I still feel like these matchers
    are a bit clumsy and weird to work with.  What is the parameter to the failure_message 
    block supposed to represent?  I often want to work with subject and actual and expected
    all at once, but it's painful to do without introducing my own variables.  Either I 
    just don't understand how to use this matcher syntax very well, or it's not intended 
    for the kind of use cases I want it for.
  * These tests have nice failure messages, but I'm not very satisfied with them as
    documentation.  They bury the "Act" part of arrange/act/assert pretty deep in the
    custom RSpec code.  If I didn't know the class under test well, it might be hard 
    to figure out from these tests how to use its interface.  
  * These tests know a lot about the implementation of the class they are testing.  
    They use that knowledge to provide more helpful failure messages, but...  If I made 
    major changes to the implementation, some of these tests would probably break.  By
    writing these tests, I've effectively widened the public interface of the class.  


I think this technique of writing tests that give detailed failure messages is powerful,
but not without cost.  There are some real tradeoffs to consider.  With regards to 
RSpec custom matchers as the specific technology used to implement that technique...
I still find myself unconvinced.  I tend to be more satisfied with assertions that I
write myself that bypass the rspec matcher framework.  


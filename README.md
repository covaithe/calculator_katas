2017-02-21

Second attempt at the strategy pattern solution.  A more complete implementation this
time, which revealed some interesting issues.  Where does the validation go?  I 
dithered for a while and ended up sticking it outside the Parser entirely.  Validation
is always a bit weird in a Parser solution, but historically we can do it in the 
constructor and feel okay with ourselves.  I couldn't quite bring myself to put the
validation in the build method though, especially since that would preclude early 
return.  Putting it in the addends method might be better, but that means holding the 
value and inspecting it before returning it, which is still awkward.  It maybe could
happen in the constructor, but that feels super weird in this case because of the 
inheritance.  Least surprise violation and all that.  I wonder if we could 
push it back out into the calculator?  Anyway, I think this certainly reveals some
weirdness that can come up with an inheritance based solution like this.  

The other interesting thing was that I dithered on whether to add another parser
subclass for multiple long delimiters.  I decided not to, since this one can handle
single or long delimiters without any conditionals, but I think the other decision
could be reasonable, at the cost of perhaps a little duplication. 

The tests are a little better this time.  there's still a "which level do I test 
this at" question, which I've answered in this case with "both".  I'm not sure nesting
all the tests inside a describe parser block is right. I might try it without that
next time. 

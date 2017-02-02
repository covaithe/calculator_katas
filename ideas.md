Things to try:


* More work on simplifying tests for the parser scenario.  
* try some of the good testing stuff on other designs, e.g. functional
* strategy pattern for the conditional parts.  Examine the string 
  early (in constructor?) and build the right parser for turning it 
  into numbers, depending on what's in the string.  E.g. custom delimiter
  would get a different parser, long custom delims another one, etc.
  Each parser is dead simple and has no conditionals.

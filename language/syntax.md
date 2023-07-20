## Classification
Pal's surface syntax is strongly influenced by Ruby, however given the fact it's a functional language. It actually looks more similar to [Elixir](https://elixir-lang.org/). 


## List of readable languages

Here's a list of language I found pretty readable to human:
- [Applescript](https://macosxautomation.com/applescript/)
- [Ruby](https://www.ruby-lang.org/)
- [Basic](https://en.wikipedia.org/wiki/BASIC)
- [Lua](https://www.lua.org/)
- [Python](https://www.python.org/)
- [Groovy](https://groovy-lang.org/)
- [Scala](https://www.scala-lang.org/)
- [Powershell](https://learn.microsoft.com/en-us/powershell/)

## A taste of Pal

Here's some code that maybe of interest: 

```
// Specify the dialect information for this source file, this is similar to racket's #lang tag
lang {
  use pattern; // allow pattern language
  use multline_string;
}

// Pattern matching:
let name of string = "Corvo"; // `let` creates a pattern matching, the semantic is similar to that of elixir
let (x of float, l = [y | rest] of list(float)) = (9.0, [9.2, 10, 13]);
let average = 0.5 * (x + y); // type annotation is optional
let average_works_as_well = 0.5 * (x + y) of float; // type annotation is optional
let (list = [first, second | rest], (uname: uname, fruit)) = ([1, 2, 3, 4], (uname: "Linux", fruit: "Apple"));
// list == [1, 2, 3, 4], first == 1, second == 2, rest == [3, 4], uname == "Linux", fruit == "Apple"

[a, a] = [1, 1]; // only binds if the two values are the same
a = 3;
^a = 3; // only binds if the rhs matches the original value of lhs
(a, a) = (1, 2); // this will fail

// if you want to return the value instead of dropping it, leave the comma just as in rust

// Basic Types

// Strings

let str = 
  \\ This is 
    \\ a series
      \\ of multiline string
        \\ Note that it is indentation insignificant
 ;

let formatted = ~f"1 + 1 = {1 + 1}%n"; // this is a f-string

// Built-in containers

// Brackets denote homongenious, while braces denote heterogeneous
[abc: "foo", def: "bar"]; // we have growable homongeneous map, borrowed from elixir
// it should be note that, this is just the short form for:
[:abc => "foo", :def => "bar"];
// just as in elixir, and yes we have keywords
:abc;
(a: "ads", b: 1, "hell" => :yeah); // we have heterogeneous ungroable named tuple(i.e. struct)
[1, 2, 3, 4]; // we have homogeneous growable list 
(1, "a", true, 4); // we have heterogenious ungrowable tuple
// I think it's possible to unify them, just like in Lua.   
~set[1, 2, 3, 4]; // and we have set
(); // we have unit i.e. empty tuple
(true, false); // we have booleans
// typed tuple should be playable at runtime via something like [milessabin/shapeless](https://github.com/milessabin/shapeless)
[1, 2, 3, 4].at(0); // accessing array 

// Bindable pattern
// This is inspired by [redplanetlabs/specter](https://github.com/redplanetlabs/specter)
a = [1, 2, 3, 4];
let (a.at(0), a.at(3)) = (3, 9); // modifying the array
// a == [3, 2, 3, 9]

// Mutability:
let counter of ref(int) = &0; // creates an atom just as in clojure. we just use c-like syntax here
counter.swap(_ + 1); // BTW here we're using something similar to scala's anonymous function
// Or: 
print(f"{*counter}%n"); // dereferencing an atom we get the underlying value
swap(counter, fn(x){x + 1});

// Function definition: 
let sum = fn(x, y, z) {
  x + y + z
} of (float, float, float).to(float);
// Or
let sum of (float, float, float).to(float) = fn(x, y, z) {x + y + z};
// Or (we also make it public) 
pub let sum = fn(x: float, y: float, z: float) float {x + y + z};

// Or just:
fn sum(x, y, z) { x + y + z };

// Calling a function
sum(4, z: 3, y: 1); // yields 8, note that positional arguments must appear before keyword arguments
// We follow UFCS(Universal Function Call Syntax)
4.sum(3, 1); // yields 8

// Partial application
4.sum(3) of float.to(float);
4.sum(3)(1); // yields 8

// note that due to partial application, the following is true:
(float, float, float).to(float) = (float, float).to(float.to(float)) = float.to(float.to(float.to(float)))

// Modules are just heterogenious maps
abc:def(); // a qualified call
// Note that above is actually just a syntax sugar for accessing fields in a map
1 = (abc: 1):abc = (abc: 1).at(:abc);

// Types

// The following if-expression has type int | string
if let a = b {
  // pattern matches!
  3 + 4
} else if c == d {
  9 * 8
} else {
  "a" ++ "b"
}
```

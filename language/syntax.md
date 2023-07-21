## Classification
Pal's syntax is strongly influenced by [Rust](https://www.rust-lang.org/).

## Note on syntax
- I don't quite like the necessity that we have to use `let` for every binding. I don't know if Honu allows this. I need more investigation. I may need to revise the syntax.

## List of readable languages

Here's a list of language I found pretty readable to human:
- With algol-like syntax
  - [Zig](https://ziglang.org/)
  - [Scala](https://www.scala-lang.org/)
  - [Groovy](https://groovy-lang.org/)
- With basic-like syntax
  - [Ruby](https://www.ruby-lang.org/)
  - [Lua](https://www.lua.org/)
  - [Python](https://www.python.org/)
  - [Applescript](https://macosxautomation.com/applescript/)
  - [Basic](https://en.wikipedia.org/wiki/BASIC)
- With sh-like syntax
  - [Powershell](https://learn.microsoft.com/en-us/powershell/)

## A taste of Pal

Here's some code that maybe of interest: 

```
// Specify the dialect information for this source file, this is similar to racket's #lang tag
lang {
  use multline_string;
};

// Pattern matching:
name :: str = "Corvo"; // pattern matching, the semantic is similar to that of elixir
(x :: float, l = [y .. rest] :: list(float)) = (9.0, [9.2, 10, 13]);
average = 0.5 * (x + y); // type annotation is optional
average_works_as_well = 0.5 * (x + y) :: float; // type annotation is optional
(list = [first, second .. rest], (uname: uname, fruit)) = ([1, 2, 3, 4], (uname: "Linux", fruit: "Apple"));
// list == [1, 2, 3, 4], first == 1, second == 2, rest == [3, 4], uname == "Linux", fruit == "Apple"

[a, a] = [1, 1]; // only binds if the two values are the same
a = 3;
^a = 3; // only binds if the rhs matches the original value of lhs
(a, a) = (1, 2); // this will fail

// if you want to return the value instead of dropping it, leave the comma just as in rust

// Basic Types

// Strings

s = 
  \\ This is 
    \\ a series
      \\ of multiline string
        \\ Note that it is indentation insignificant
 ;

formatted = ~f"1 + 1 = {1 + 1}\n"; // this is a f-string

// Built-in containers

// Brackets denote homongenious, while braces denote heterogeneous
[abc: "foo", def: "bar"]; // we have growable homongeneous map, borrowed from elixir
// it should be note that, this is just the short form for:
[:abc => "foo", :def => "bar"];
// just as in elixir, and yes we have keywords
:abc;
(a: "ads", b: 1, "hell" => :yeah) 
:: tuple(a: str, b: int, "hell" => keyword)
; // we have heterogeneous ungroable named tuple(i.e. struct)
[1, 2, 3, 4]; // we have homogeneous growable list 
(1, "a", true, 4); // we have heterogenious ungrowable tuple
// I think it's possible to unify them, just like in Lua.   
~set[1, 2, 3, 4]; // and we have set
(); // we have unit i.e. empty tuple
(true, false); // we have booleans
// typed tuple should be playable at runtime via something like [milessabin/shapeless](https://github.com/milessabin/shapeless)
[1, 2, 3, 4].at(0); // accessing array 

// Bindable pattern
// This is inspired by [redplanetlabs/specter](https://github.com/redplanetlabs/specter) and C#'s LINQ
a = [1, 2, 3, 4];
let (a.at(0), a.at(3)) = (3, 9); // modifying the array
// a == [3, 2, 3, 9]

// Mutability:
counter :: ref(int) = &0; // creates an atom just as in clojure. we just use c-like syntax here
counter.swap(_ + 1); // BTW here we're using something similar to scala's anonymous function
// I need some tricks in the compiler to make this compile as well. Something come to mind: haskell's do notation.
let counter = counter + 1
// Or: 
print(f"{*counter}%n"); // dereferencing an atom we get the underlying value
swap(counter, fn(x){x + 1});

// Function definition: 
let sum = fn(x, y, z) {
  x + y + z
} :: (float, float, float).to(float);
// Or
let sum :: (float, float, float).to(float) = fn(x, y, z) {x + y + z};
// Or (we also make it public) 
pub let sum = fn(x: float, y: float, z: float) float {x + y + z};

// Or just:
fn sum(x, y, z) { x + y + z }

// vararg version of sum, along with pattern matching
// note that semicolon maybe omitted here.
// `...` is the shorthand for `.. ...`, its value depends on the context
fn sum(...) {
  match ... {
    [] -> 0
    [first ...]  -> apply(sum, rest) + first
  }
}

// `_` discard the values 
[_ .. rest] = [1, 2, 3, 4] // rest = [2, 3, 4]

// `?abc` requires compiler to query the type of the hole
?abc = 1 // compiler will yield: ?abc :: int 

// Calling a function
sum(4, z: 3, y: 1); // yields 8, note that positional arguments must appear before keyword arguments
// We follow UFCS(Universal Function Call Syntax)
4.sum(3, 1); // yields 8

// Partial application
4.sum(3) :: float.to(float);
4.sum(3)(1); // yields 8

// note that due to partial application, the following is true:
(float, float, float).to(float) = (float, float).to(float.to(float)) = float.to(float.to(float.to(float)))

// Modules are just heterogenious maps
abc:def(); // a qualified call
// Note that above is actually just a syntax sugar for accessing fields in a map
1 = (abc: 1):abc = (abc: 1).at(:abc);

// Types

// The following if-expression has type int | string
if { a = b = c }.ok? {
  // pattern matches! 
  // you can call a function without parens! (only works for dot notation)
  3 + 4
} else if c == d {
  9 * 8
} else {
  "a" ++ "b"
}

// We have control structures
// they have an imperative interface but can be used functionally
// I may need to take a look at Common Lisp, Scala, Zig, F# and Hy lang to decide how to desig them precisely.
// here the syntax is similar to what we have in zig.
i = {
  break 1;
}

```
